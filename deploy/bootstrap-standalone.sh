#!/usr/bin/env bash
# C1-7 install 基础框架 · CLI bootstrap（Phase 1）
# 规范：docs/platform/delivery/私有化装机与双交付.md §3 · install-Phase1 §C1-7
# 行为：MySQL/Redis + install manifest 最小 SQL + install.lock · Web `/install` 向导见 platform StandaloneInstallController
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
APP_DIR="${APP_DIR:-/data/apps/ztdh-install}"
COMPOSE_DATA="${APP_DIR}/docker-compose.data.yml"
ENV_FILE="${APP_DIR}/.env"
INSTALL_LOCK="${APP_DIR}/install.lock"
SQL_DIR="${SQL_DIR:-${REPO_ROOT}/sql/mysql}"
GITLAB_RAW_BASE="${GITLAB_RAW_BASE:-https://gitlab.zrlmeng.com:51880/development-specifications/kuikly-yudao-enterprise-baseline/-/raw/main/ruoyi-vue-pro/sql/mysql}"

if [ -f "${INSTALL_LOCK}" ]; then
  echo "SKIP: already bootstrapped at $(tr -d '\r\n' < "${INSTALL_LOCK}")"
  exit 0
fi

mkdir -p "${APP_DIR}"
if [ ! -f "${COMPOSE_DATA}" ]; then
  cp "${SCRIPT_DIR}/docker-compose.data.yml" "${COMPOSE_DATA}"
fi

if [ ! -f "${ENV_FILE}" ]; then
  MYSQL_ROOT_PASSWORD="$(openssl rand -hex 16)"
  cat > "${ENV_FILE}" <<EOF
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_DATABASE=ruoyi-vue-pro
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=dev,staging
# install runtime · ztdh.edition=standalone（规划 yaml 键；当前经 license + delivery tier 表达）
YUDAO_LICENSE_RUNTIME_EDITION=install
YUDAO_LICENSE_RUNTIME_ONLINE_REQUIRED=true
YUDAO_LICENSE_RUNTIME_OFFLINE_GRACE_HOURS=0
YUDAO_INSTALL_WEB_ENABLED=true
SPRING_DATASOURCE_DYNAMIC_DATASOURCE_MASTER_URL=jdbc:mysql://ztdh-install-mysql:3306/ruoyi-vue-pro?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&nullCatalogMeansCurrent=true&rewriteBatchedStatements=true&connectionCollation=utf8mb4_unicode_ci
SPRING_DATASOURCE_DYNAMIC_DATASOURCE_MASTER_USERNAME=root
SPRING_DATASOURCE_DYNAMIC_DATASOURCE_MASTER_PASSWORD=${MYSQL_ROOT_PASSWORD}
SPRING_DATASOURCE_DYNAMIC_DATASOURCE_SLAVE_URL=jdbc:mysql://ztdh-install-mysql:3306/ruoyi-vue-pro?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&nullCatalogMeansCurrent=true&rewriteBatchedStatements=true&connectionCollation=utf8mb4_unicode_ci
SPRING_DATASOURCE_DYNAMIC_DATASOURCE_SLAVE_USERNAME=root
SPRING_DATASOURCE_DYNAMIC_DATASOURCE_SLAVE_PASSWORD=${MYSQL_ROOT_PASSWORD}
SPRING_DATA_REDIS_HOST=ztdh-install-redis
SPRING_DATA_REDIS_PORT=6379
SPRING_DATA_REDIS_DATABASE=2
EOF
  chmod 600 "${ENV_FILE}"
  echo "created ${ENV_FILE}"
fi

set -a
# shellcheck source=/dev/null
source "${ENV_FILE}"
set +a

docker network create ztdh-install-net 2>/dev/null || true
docker compose -f "${COMPOSE_DATA}" --env-file "${ENV_FILE}" -p ztdh-install-data up -d
docker compose -f "${COMPOSE_DATA}" -p ztdh-install-data ps

echo "waiting for mysql..."
for i in $(seq 1 60); do
  if docker exec ztdh-install-mysql mysqladmin ping -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" --silent 2>/dev/null; then
    break
  fi
  sleep 2
done

import_sql() {
  local name="$1"
  local path="${SQL_DIR}/${name}"
  if [ -f "${path}" ]; then
    echo "import local ${name}"
    docker exec -i ztdh-install-mysql mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" < "${path}"
    return 0
  fi
  if curl -fsSL "${GITLAB_RAW_BASE}/${name}" -o "/tmp/${name}" 2>/dev/null; then
    echo "import remote ${name}"
    docker exec -i ztdh-install-mysql mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" < "/tmp/${name}"
    return 0
  fi
  echo "WARN: skip missing ${name}" >&2
  return 0
}

if [ ! -f "${APP_DIR}/.sql-imported" ]; then
  # 官方大库（若本地/远程可用）
  import_sql "ruoyi-vue-pro.sql"
  for sql_name in \
    license-baseline.sql \
    app-common-baseline.sql \
    app-common-menu-baseline.sql \
    app-common-tenant-package-menus.sql \
    app-message-baseline.sql \
    app-account-extensions.sql \
    member-email-baseline.sql \
    delivery-upgrade-plans-baseline.sql \
    platform-market-sku-baseline.sql \
    platform-market-sku-price-fen.sql \
    platform-market-pay-order.sql \
    platform-market-menu-baseline.sql \
    platform-market-collect-menu.sql \
    tenant-license-readonly-menu.sql \
    install-oauth2-client-seed.sql; do
    import_sql "${sql_name}" || true
  done
  touch "${APP_DIR}/.sql-imported"
  echo "SQL import done"
elif [ ! -f "${APP_DIR}/.runtime-sql-applied" ]; then
  # 已有基础库：仅补运行面最小集
  for sql_name in \
    delivery-upgrade-plans-baseline.sql \
    platform-market-sku-baseline.sql \
    platform-market-sku-price-fen.sql \
    platform-market-pay-order.sql \
    platform-market-menu-baseline.sql \
    platform-market-collect-menu.sql \
    tenant-license-readonly-menu.sql \
    install-oauth2-client-seed.sql; do
    import_sql "${sql_name}" || true
  done
  date -u +"%Y-%m-%dT%H:%M:%SZ" > "${APP_DIR}/.runtime-sql-applied"
  echo "runtime SQL supplement done"
fi

date -u +"%Y-%m-%dT%H:%M:%SZ" > "${INSTALL_LOCK}"
chmod 644 "${INSTALL_LOCK}"
echo "OK install bootstrap at ${APP_DIR} (lock=$(cat "${INSTALL_LOCK}"))"
echo "Next: deploy runtime JAR on port 7060 · smoke: bash script/shell/smoke-install-bootstrap.sh"
