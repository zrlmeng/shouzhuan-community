# 预发人工验收签字单（CLOSED-LOOP · C3）

| 项 | 值 |
|----|-----|
| 产品 | 装机基础框架 `products/install`（②）+ 私有化（③） |
| 环境 | **业务预发** `https://install-staging.zrlmeng.com/` · 端口 7060 |
| 日期 | 2026-08-28（材料刷新至 enc 1.0.2；签字仍空） |
| **安装包下载** | 本机 enc **1.0.2** 已打包（§0）；预发 downloads 待运维上传 |
| 机检预检 | ✅ closed-loop PASS · ✅ enc 1.0.2 本机打包 |
| 口径 | **≠** earnstore Q售；**≠** 生产发版 |
| 商10 材料 | ✅ **材料就绪**（包/下载/走查表/机检脚本齐）；签字区仍空 → CLOSED-LOOP 商10/C3 保持 ⏳ |

> **本单须人工走查 + 签字** 后，方可把 CLOSED-LOOP §C3 / 商10 勾为完成。  
> Agent / 机检不能代替签字。  
> **未齐不可售**：签字前不得对外宣称装机/私有化可售。

---

## 0. 交付包（② / ③ · 加密版 enc）

| 框架 | 包名 | 下载 |
|------|------|------|
| **② 装机** | `ztdh-install-enc-1.0.2.tar.gz`（~356MB） | [下载](M:/useCode/KuiklyYudaoEnterpriseBaseline/ruoyi-vue-pro/target/install-editions/ztdh-install-enc-1.0.2.tar.gz) |
| **③ 私有化** | `ztdh-onprem-enc-1.0.2.tar.gz`（~356MB） | [下载](M:/useCode/KuiklyYudaoEnterpriseBaseline/ruoyi-vue-pro/target/install-editions/ztdh-onprem-enc-1.0.2.tar.gz) |
| 校验 | `SHA256SUMS-1.0.2.txt` | [校验文件](M:/useCode/KuiklyYudaoEnterpriseBaseline/ruoyi-vue-pro/target/install-editions/SHA256SUMS-1.0.2.txt) |
| 备选 oss | `（oss 过审备包另打；C3 默认 enc）` | 同 downloads 目录（过审备包） |

目录页：https://install-staging.zrlmeng.com/downloads/

本地副本（开发机）：`ruoyi-vue-pro/target/install-editions/`  
打包命令：`python products/install/scripts/package-framework-delivery.py --editions enc --version 1.0.2`

> ②与③ **同一 runtime JAR 线**；差别仅在环境变量（`install` 联网强制 vs `standalone` 允许离线 JCA）。

### 0.1 本机从零安装（全流程）

```bash
# ② 装机
tar -xzf ztdh-install-enc-1.0.2.tar.gz
cd ztdh-install-enc-1.0.2
cp .env.example .env   # 改 MYSQL_PASSWORD；端口冲突改 APP_PORT/MYSQL_PORT/REDIS_PORT
bash install.sh
# 打开 http://127.0.0.1:8080/install → 完成向导 → License → 加购 appmarket.core

# ③ 私有化（勿与②同机同端口；包内默认 8081/3307/6380）
tar -xzf ztdh-onprem-enc-1.0.2.tar.gz
cd ztdh-onprem-enc-1.0.2
cp .env.example .env
bash install.sh
# http://127.0.0.1:8081/install → 可测离线 CRL / upgrade-plans
```

前置：本机 Docker + Compose；需能拉 `mysql:8.0` / `redis:7-alpine` / `eclipse-temurin:25-jre`（或国内镜像）。

---

## 1. 人工走查清单（请逐项勾选）

| # | 步骤 | 期望 | 勾选 | 备注 / 截图 |
|---|------|------|------|-------------|
| H0 | 下载并校验两个 tar.gz（SHA256） | 校验通过 | ☐ | |
| H0a | ② 包 `bash install.sh` 拉起 | `/install` 可开；健康正常 | ☐ | |
| H0b | ③ 包 `bash install.sh` 拉起 | 独立端口；edition=standalone | ☐ | |
| H1 | ② `/install` **六步**走完（协议→环境→库确认→管理员→License→完成） | `install.lock` / `completed`；②须联网激活成功 | ☑ 机检 | 预发种子 **licenseNo=`LIC-STAGING-ACCEPT-1`** · nodeId=`node-1` · [证据](./evidence/staging-h1-wizard-complete-2026-07-30.md) |
| H2 | ② License + 目录可见 `appmarket.core` | purchasable / 可读 | ☐ | |
| H3 | ② 加购 `appmarket.core` | entitlements / owned | ☐ | |
| H4 | ② updates 含 `backend-app-appmarket` | manifest 可见 | ☐ | |
| H5 | ③ 离线 CRL 导入 | import-revocations 成功 | ☐ | |
| H6 | ③ 坏制品拒签 | 业务错误非 5xx | ☐ | |
| H7 | 站长说明无内网泄露 | 对照 SITE-ADMIN-README | ☐ | |

**亦可**对照已部署预发 `https://install-staging.zrlmeng.com/` 做加购体验（**不能替代** H0 本机装包）。

**禁止验收口径**：earnstore Q售、生产 kid、宝塔市场过审（§C2）。

---

## 2. 签字区

| 角色 | 姓名 | 结论（PASS / FAIL） | 日期 | 签字 |
|------|------|---------------------|------|------|
| 交付 / 安全抽检 | | | | |
| 产品 / 站长代表（可选） | | | | |

失败时：在备注写缺口；修完后开新行复验，勿涂改原行。

---

## 3. 机检复跑（签字前可选）

```powershell
$env:YUDAO_SMOKE_BASE="https://install-staging.zrlmeng.com"
$env:YUDAO_ADMIN_PASSWORD="admin123"
python products/install/scripts/smoke-first-addon-local.py
$env:YUDAO_BASE_URL="https://install-staging.zrlmeng.com"
python products/install/scripts/smoke-install-admin-deep.py
```

**2026-08-27 机检**：上述脚本 PASS（见 [NEXT-DOCS-AND-INSTALL-C3](../../app-official-site/doc/operations/NEXT-DOCS-AND-INSTALL-C3.md) §B1）。

---

## 4. 完成后

1. 本文件勾选填满 + 签字区非空  
2. 另存 `products/install/evidence/human-acceptance-staging-C3-2026-07-30.md`  
3. CLOSED-LOOP §C3 → ✅  
4. 变更日志记一笔

---

## 变更

| 版本 | 日期 | 说明 |
|------|------|------|
| 1.1.2 | 2026-08-27 | 机检复跑 PASS（first-addon + admin-deep）；合并下一步见 [NEXT-DOCS-AND-INSTALL-C3](../../app-official-site/doc/operations/NEXT-DOCS-AND-INSTALL-C3.md) |
| 1.1.1 | 2026-07-31 | 商10：标注材料就绪；签字前商10/C3 仍 ⏳、未齐不可售 |
| 1.1.0 | 2026-07-30 | 补 ②③ enc 安装包下载与本机全流程步骤 |
| 1.0.0 | 2026-07-30 | 首版：预发就绪 + 机检预检 · 待人工签字 |
