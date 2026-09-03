#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] docker required"
  exit 1
fi
if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "[INFO] created .env from .env.example"
fi

# MySQL：空口令或弱占位 → 自动生成强密码；Redis 密码可选（默认可不配）
is_weak_mysql_password() {
  local p="${1:-}"
  [[ -z "${p}" ]] && return 0
  case "${p}" in
    ChangeMe_*|changeme*|password|Password|123456|root|admin|admin123|mysql|test) return 0 ;;
  esac
  [[ ${#p} -lt 16 ]] && return 0
  echo "${p}" | grep -q '[A-Z]' || return 0
  echo "${p}" | grep -q '[a-z]' || return 0
  echo "${p}" | grep -q '[0-9]' || return 0
  echo "${p}" | grep -q '[^A-Za-z0-9]' || return 0
  return 1
}

gen_strong_mysql_password() {
  # ≥24：大写+小写+数字+符号，降低字典/暴力破解面
  local u l d s
  u="$(openssl rand -base64 48 2>/dev/null | tr -dc 'A-HJ-NP-Z' | head -c 6)"
  l="$(openssl rand -base64 48 2>/dev/null | tr -dc 'a-hj-np-z' | head -c 10)"
  d="$(openssl rand -base64 48 2>/dev/null | tr -dc '2-9' | head -c 6)"
  s="$(openssl rand -base64 48 2>/dev/null | tr -dc '@#%^*_+=' | head -c 4)"
  if [[ ${#u} -lt 4 || ${#l} -lt 4 || ${#d} -lt 4 || ${#s} -lt 2 ]]; then
    # 无 openssl 时兜底
    u="K7Qm"; l="xwphnvdk"; d="394821"; s="@#^*"
  fi
  printf '%s' "${u}${l}${d}${s}"
}

ensure_mysql_password() {
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
  if ! is_weak_mysql_password "${MYSQL_PASSWORD:-}"; then
    return 0
  fi
  local neu
  neu="$(gen_strong_mysql_password)"
  if grep -qE '^[[:space:]]*MYSQL_PASSWORD=' .env; then
    # 仅替换赋值行，保留注释
    awk -v p="${neu}" 'BEGIN{done=0} /^[[:space:]]*MYSQL_PASSWORD=/{print "MYSQL_PASSWORD=" p; done=1; next} {print} END{if(!done) print "MYSQL_PASSWORD=" p}' .env > .env.tmp
    mv .env.tmp .env
  else
    printf '\nMYSQL_PASSWORD=%s\n' "${neu}" >> .env
  fi
  umask 077
  printf 'MYSQL_PASSWORD=%s\nGENERATED_AT=%s\nNOTE=copy-once-then-store-offline\n' "${neu}" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > .mysql-credentials.once
  chmod 600 .env .mysql-credentials.once 2>/dev/null || true
  echo "[OK] MySQL root 密码已按强度规则自动生成（仅展示一次）"
  echo "     ${neu}"
  echo "     已写入 .env 与 .mysql-credentials.once（权限 600）；请立即离线保存，勿提交公开仓"
  echo "[INFO] Redis 密码默认可不配；若需 requirepass，可自行在 .env 增加 REDIS_PASSWORD（当前编排默认无 Redis 密码）"
}

ensure_mysql_password

if [[ ! -f app/yudao-server.jar ]]; then
  echo "[ERROR] missing app/yudao-server.jar"
  exit 1
fi
set -a
# shellcheck disable=SC1091
source .env
set +a
echo "[INFO] starting ${APP_NAME} edition=${FRAMEWORK} license=${YUDAO_LICENSE_RUNTIME_EDITION}"
docker compose --env-file .env up -d
echo "[INFO] waiting health on :${APP_PORT:-8080} ..."
ok=0
for i in $(seq 1 60); do
  if curl -fsS "http://127.0.0.1:${APP_PORT:-8080}/actuator/health" >/dev/null 2>&1 \
    || curl -fsS -H 'tenant-id: 1' "http://127.0.0.1:${APP_PORT:-8080}/app-api/system/area/tree" >/dev/null 2>&1; then
    ok=1
    break
  fi
  sleep 3
done
if [[ "$ok" != "1" ]]; then
  echo "[ERROR] not healthy in time"
  docker compose --env-file .env ps
  exit 1
fi
# 首启：幂等导入运行面最小补充 SQL（oauth / 市场菜单 / upgrade-plans）
if [[ -d sql ]] && [[ ! -f .runtime-sql-applied ]]; then
  echo "[INFO] applying runtime SQL via mysql container..."
  MYSQL_CID="$(docker compose --env-file .env ps -q mysql)"
  if [[ -n "${MYSQL_CID}" ]]; then
    for f in sql/*.sql; do
      [[ -f "$f" ]] || continue
      echo "  import $(basename "$f")"
      docker exec -i "${MYSQL_CID}" mysql -uroot -p"${MYSQL_PASSWORD}" --default-character-set=utf8mb4 "${MYSQL_DB}" < "$f" \
        || echo "  WARN $(basename "$f") (may be idempotent)"
    done
    date -u +"%Y-%m-%dT%H:%M:%SZ" > .runtime-sql-applied
  else
    echo "[WARN] mysql container not found; skip SQL (run apply-install-runtime-sql later)"
  fi
fi
echo "[OK] up — open http://127.0.0.1:${APP_PORT:-8080}/install"
exit 0
