# 守赚社区版 · 基础框架

> **对外主名：守赚社区版**（旧称「社区版 / 装机版 / 社区版市场」）。工程 `product_id: install` 不变。  
> Agent：`.cursor/rules/project-community-edition.mdc`

| 项 | 值 |
|----|-----|
| manifest | [product-manifest.yaml](./product-manifest.yaml) |
| **Day1 入口** | **[DAY1.md](./DAY1.md)** |
| **开发闭环清单** | **[CLOSED-LOOP-CHECKLIST.md](./CLOSED-LOOP-CHECKLIST.md)** |
| **下一步 Sprint（G1）** | **[INSTALL-NEXT-PHASE-DEV.md](./INSTALL-NEXT-PHASE-DEV.md)**（ProGuard Wave 2.1 · Wave 3 余项） |
| **商7 装包执行器（G0）** | **[CAPABILITY-INSTALL-EXECUTOR-SPEC.md](./CAPABILITY-INSTALL-EXECUTOR-SPEC.md)**（L-Eng/L-Biz · API v2 · tar · 验收） |
| **开放平台商业化路线** | **[OPEN-PLATFORM-COMMERCE-ROADMAP.md](./OPEN-PLATFORM-COMMERCE-ROADMAP.md)**（Hub / 装机市场 / Wave0–3） |
| **应用市场站点购用开发（G0）** | **[MARKET-SITE-PURCHASE-TO-USE-DEV.md](./MARKET-SITE-PURCHASE-TO-USE-DEV.md)**（open/store 下单→装包→真用 · Agent 主入口） |
| 首加购演示 | [FIRST-ADDON-DEMO.md](./FIRST-ADDON-DEMO.md)（本地 48101 / 预发 7060 → `appmarket.core`） |
| **框架本地 Docker（FW2）** | `docker-compose.framework-local.yml` · 口 **48101** · 账号 **`yudao`/`admin123`** · 硬门禁 `$env:INSTALL_SMOKE_HARD=1` → [升硬证据](../../docs/platform/ztdh-program/能力超市大升级-2026-07/evidence/FW2-5/PASS-20260828-hardening.md) |
| 站长说明 | [SITE-ADMIN-README.md](./SITE-ADMIN-README.md) |
| CDN / 体积 / Vben / 升级演练 / 值班 | [CDN Runbook](./CDN-CAPABILITY-ARTIFACT-RUNBOOK.md) · [装包 SPEC](./CAPABILITY-INSTALL-EXECUTOR-SPEC.md) · [体积策略](./DELIVERY-PACKAGE-SIZE-STRATEGY.md) · [RUNTIME-VBEN](./RUNTIME-VBEN-MENU-TRIM.md) · [升级演练](./CUSTOMER-UPGRADE-DRILL.md) · [值班 SLA](./LICENSE-DUTY-SLA-HANDBOOK.md) |
| 开发指南 | [社区版与独立部署开发指南](../../docs/platform/delivery/社区版与独立部署开发指南.md) |
| 上架说明 | [MARKETPLACE.md](./MARKETPLACE.md) · 站长随附 [SITE-ADMIN-README.md](./SITE-ADMIN-README.md) · **阿里云** [上架方案](../../docs/platform/delivery/社区版-阿里云云市场上架方案.md) · [ALIYUN-MARKET-SUBMIT](./ALIYUN-MARKET-SUBMIT.md) · **公网三平台（默认仅 enc）** [总规](../../docs/platform/delivery/社区版-enc公网三平台发布规范（GitHub·Gitee·Docker-Hub）.md) · [GITHUB](./GITHUB-COMMUNITY-SUBMIT.md) · [GITEE](./GITEE-COMMUNITY-SUBMIT.md) · [Docker Hub](../../docs/platform/delivery/社区版-Docker-Hub发布规范.md) · [DOCKER-HUB-SUBMIT](./DOCKER-HUB-SUBMIT.md) |

## 定位（与四线 L3 的区别）

| | **社区版（本目录）** | `products/{earn,browser,survey,weather,earnstore}` |
|---|---------------------|------------------------------------------|
| 卖什么 | **一个** 基础框架 SKU（oss/enc） | 线路 B / 垂直产品 |
| 出厂模块 | 内核 + 壳 + **应用市场客户端** | 单 L 主业务 + 壳 |
| 垂直能力 | **不固定** — remote_market 按需装 | 出厂或产品线固定 |
| 706x 预发 | **183** `prod-biz-staging` · **7060**（install） | 见各产品 DEPLOY · 角色 [docs/164](../../docs/164-母版与公司服务器角色速查.md) |

## 用户路径

1. 安装 **基础框架**（默认 **加密版**；过审可用 **开源版**薄源）+ License 联网激活  
2. 租户后台 **应用市场**（与主站 capability 目录同步）  
3. 选购能力（首样板推荐 **`appmarket.core`**；亦可 earn/browser/…）  
4. **市场站点下单**（`open` / `store`）→ Grant → **Admin 选择性装包** → 真用验收 — 端到端见 **[MARKET-SITE-PURCHASE-TO-USE-DEV](./MARKET-SITE-PURCHASE-TO-USE-DEV.md)**；装包细则 [CAPABILITY-INSTALL-EXECUTOR-SPEC](./CAPABILITY-INSTALL-EXECUTOR-SPEC.md)

> remote_market：**C3 本地已收口**；首加购本地证据见 FIRST-ADDON-DEMO；预发见清单 §C。

## 工程状态（2026-07-30）

| 项 | 状态 |
|----|------|
| runtime 裁剪 JAR + CI 验签 | ✅ C1 |
| enc JAR ProGuard 加固（G1 · Wave 2.1） | ✅ **message+account+moderation+staff** 生产 `20260825-0941` · **`app-common` 裁决暂缓**（[163 §3.1.1](../../docs/163-社区版Runtime-JAR-ProGuard混淆规范.md)） |
| sdk-app-template + bootstrap | ✅ |
| remote_market 本地 + `appmarket.core` 加购 | ✅ |
| 双版本流水线 / 宝塔双包 / Web `/install` | ✅ |
| ③ JCA 离线导入 + `delivery_upgrade_plans` | ✅ 开发闭环 |
| 本地 Docker ②+③ 全功能冒烟 | ✅ [framework-docker-local-smoke](./evidence/framework-docker-local-smoke.md) |
| 文档 Day1 / 授权 / 双版本 / 闭环清单 | ✅ |
| 7060 预发实跑 / 市场人工过审 | ✅ 预发已通 · 首加购机检 PASS；**人工签字**见 [HUMAN-ACCEPTANCE-STAGING-C3](./HUMAN-ACCEPTANCE-STAGING-C3.md)；市场过审仍 ⏳ |

## 社区 Admin 菜单自检（运行面）

站长后台应只有 **「框架与能力更新」**（`tenant/instance-updates`）与 **「应用市场」**（只读同步 + 加购），**不得**出现母版「发布清单 / 推送节点」或 **「市场 SKU」** 创建/编辑/删除。

1. 对社区库执行（可重复）：
   - `ruoyi-vue-pro/sql/mysql/platform-updates-runtime-menu-guard.sql`
   - `ruoyi-vue-pro/sql/mysql/platform-deployment-node-push-signal.sql`（推送信号列）
2. 确认 `yudao.platform.deployment-role=runtime`（`application-product-install.yaml`）
3. 登录 Admin：左侧进入 **框架与能力更新**，页顶有 **检查更新 / 触发本节点检测**
4. 直链 `#/platform/updates` 应重定向到 `#/tenant/instance-updates`（`.env.install` 的 `VITE_PLATFORM_DEPLOYMENT_ROLE=runtime`）
5. 调用 `POST /admin-api/platform/updates/draft/create` 应返回 **控制面专用** 403

母版发版后社区跟版 SOP：见 [docs/73 §4](../docs/73-实例更新与远程市场.md) · [控制面运营手册](../docs/platform/delivery/控制面运营手册（License与市场）.md) §母版发版后社区跟版

## 上架说明

见 [MARKETPLACE.md](./MARKETPLACE.md) · 站长随附 [SITE-ADMIN-README.md](./SITE-ADMIN-README.md)。  
阿里云云市场（License 不去掉）：[上架方案](../../docs/platform/delivery/社区版-阿里云云市场上架方案.md) · [ALIYUN-MARKET-SUBMIT](./ALIYUN-MARKET-SUBMIT.md)。
