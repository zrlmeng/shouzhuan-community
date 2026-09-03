# 社区版 · 站长 README（客户可见）

| 项 | 值 |
|----|-----|
| 版本 | 1.4.13 |
| 日期 | 2026-08-21 |
| 适用 | 宝塔/源码站上架包随附说明 |

> **禁止**写入：公司内网 IP、GitLab 内网地址、签发私钥路径、未公开 admin 拓扑、公众号 AppSecret。

---

## 1. 你得到什么

- **加密版（推荐）**：可运行 runtime，无业务源码  
- **开源版（过审）**：极薄可审计源 + 同等 License 强度  
- 内置 **应用市场**（与官方能力目录同步）  
- **必须联网** 完成 License 激活与心跳（装机默认无离线宽限）

---

## 1.1 站长后台三入口（登录后看这里）

登录管理端后，打开左侧 **APP 业务中心**（不要找母版「商城 / 一物一码 / 官网页面」——社区版 runtime **不含**这些模块，点开会报「请求地址不存在」属正常裁剪）。

| 你要找的 | 菜单位置 | 说明 |
|----------|----------|------|
| **已购 / 待装包 / 装包** | **APP 业务中心 → 应用市场** | 只读目录 + 已购状态；**不下单**（对标微擎站长后台） |
| **购买官方能力 / 套餐** | **守赚官方能力市场** `https://open.zrlmeng.com/market` | **官方**唯一下单站；套餐标价 → 结账 |
| **购买开发者应用** | **守赚开发者应用市场** `https://store.zrlmeng.com` | **ISV** 货架下单；与 open **分域** |
| **免费激活证书到期时间** | **APP 业务中心 → 授权状态** | 只读：授权码、状态、到期时间、剩余天数；续费链接默认 **`https://open.zrlmeng.com/license/renew`**（Hub · docs/153 禁 `www`） |
| **框架检查更新** | **APP 业务中心 → 框架与能力更新** | 对照当前装机 `frameworkVersion` 看更新清单；大版本按合同窗口 |
| **垂直加购（盈利）** | 官方 → open；开发者货 → store（勿在装机后台结账） | Collect → Grant；装机侧仅履约装包 |

> **站点根域名**：`https://install.zrlmeng.com/` 会自动跳转——未装完 → `/install`；已装完 → 管理端入口。勿把根路径当 API（会看到「账号未登录」JSON）。

> 侧栏若仍出现商城、CRM、一物一码等：说明库未跑装机菜单裁剪，请运维执行  
> `sql/mysql/install-foundation-menu-trim.sql` + `sql/mysql/install-community-site-admin-menus.sql` 后重新登录。

---

## 2. 安装

1. 按宝塔脚本或 Docker Compose 拉起（见包内 `bt-install-enc.sh` / `bt-install-oss.sh`）；**MySQL** 与 **Redis** 在编排/脚本中已配好  
   - **MySQL**：`.env` 中 `MYSQL_PASSWORD` 为空或弱口令时，`install.sh` **自动生成** ≥24 位强密码（大小写 + 数字 + 符号），控制台与 `.mysql-credentials.once` **各展示一次**，请立即离线保存  
   - **Redis**：密码**可不配**（默认无 `requirepass`）；仅在内网策略要求时再自行设置  
2. 浏览器打开：`http://<你的服务器公网域名或IP>:<端口>/install`  
3. 向导标题下会显示 **框架版本**（如 `v1.0.0`，与交付包 `FRAMEWORK_VERSION` / `.env` 的 `YUDAO_FRAMEWORK_VERSION` 一致）。完成后 `install.lock` 也会写入该版本，供日后后台「框架与能力更新」对照发版。  
4. 按 **六步向导** 完成（产品名：**守赚社区版**）：  
   - ① 用户协议 + 隐私摘要（须双勾选；条款含免责与责任上限，请完整阅读）  
   - ② 环境检测（Java / 目录可写等，项级通过）  
   - ③ **MySQL / Redis** 连通确认（只读脱敏展示主机与库名，不在此步改连接串；推荐库名 `shouzhuan_community`）  
   - ④ 管理员说明（**自动强密码** + **按规则生成高熵后台入口**，形如 `xxxxxx-xxxxxx-xxxxxx`，可重新生成/手工改；勿用全网雷同默认地址）  
   - ⑤ **微信扫码领取免费框架授权**并本机激活（主路径；同一微信号一份）。向导展示公众号**名称 + 微信号 + AppID**。**节点编号由系统自动生成**（只读展示，如 `node-a1b2c3d4e5f6`），用于授权绑定与日后升级；仅运维旁路可改  
   - ⑥ 完成 → 写入安装标记，**一次性展示用户名/强密码与后台完整 URL**（支持复制 / 保存到本地 txt）→ 进入 **同机完整管理端（Vben）** 并立即改密   
4. 管理端登录并改密 → 侧栏 **应用市场** 查看已购/待装；**购买请到** [守赚能力市场](https://open.zrlmeng.com/market)（样板能力：`appmarket.core`，≠ 其它垂直产品 Q 售）

> **管理端入口（可配置）**：安装向导第 4 步按规则生成高熵路径（20 位三段 `a–z0–9`，禁止 admin/mgmt 等弱前缀），可「重新生成」或自定义；同机托管**完整裁剪版管理端**（含应用市场菜单）。旧地址 `/admin-ui/` 仅 **302 跳转**到当前入口。鉴权仍靠强密码 + `/admin-api`；入口混淆用于降低扫路径撞库，**不能替代强密码**。

> 数据层：向导第 3 步会明确展示 **MySQL**、**Redis** 产品名与连通结果，便于运维核对。新建实例推荐 MySQL 库名 **`shouzhuan_community`**（与产品「守赚社区版」一致）；已上线旧库名可继续使用，以实际连接配置为准。向导**不会**展示数据库口令明文（口令在 `install.sh` / `.mysql-credentials.once`）。

官方文档入口：**[https://docs.zrlmeng.com/community/](https://docs.zrlmeng.com/community/)**（社区版站长手册；勿依赖口头内网地址）。\n\n最短路径：[**20 分钟装完**](https://docs.zrlmeng.com/community/install/quickstart-20min)。

---

## 3. License

- **社区版主路径**：向导第 5 步用微信扫描 **「守赚云」** 公众号授权页（与赚钱浏览器 H5 同一公众号，`SocialType=31`），控制面签发 `framework-free-community` 免费框架证后，本机自动 `activate`  
- **一微信号一证**：同一微信 openid 重复领取返回原授权码，不重复签发  
- 商业加购 / 合同定制码仍由官方控制面签发后交付（见 [LICENSE-ISSUE-RUNBOOK](./LICENSE-ISSUE-RUNBOOK.md)）  
- 站长控制台「授权状态」为**只读**（续费/吊销走官方渠道；见 [CONTROL-PLANE-VS-RUNTIME](./CONTROL-PLANE-VS-RUNTIME.md)）  
- 页内展示 **剩余天数**；临近到期（≤30 / ≤7 天）会醒目提示，并提供续费链接（若控制面已下发 `renewHintUrl`）  
- 客户机通过 `yudao.install.claim-base-url` 代理控制面领证 API；本机只负责激活（运行面无签发私钥）  
- 续费、加购、吊销以服务端为准  
- 勿尝试关闭验签或替换包内密钥  
- **预发验收码**仅在官方预发环境由运维开启提示；生产包不会内置验收码  

---

## 4. 应用市场与更新（微擎可参考项）

本产品**只借鉴站长体验**，不抄 PHP 模块架构。可对齐的体验点：

| 体验点 | 本产品落点 |
|--------|------------|
| 公网市场站买模块 | **Hub** `open.zrlmeng.com/market` → `/pricing` → `/checkout`（唯一下单面） |
| 后台只装已授权模块 | 装机「应用市场」：已购 / 待装包 / 装包；**禁止后台结账** |
| 应用状态分栏 | 应用市场：可加购（跳 Hub）/ 已购 / 待装包 / 即将上架 |
| 更新前确认 | 框架与能力更新「推送节点」：备份 + 制品完整性 + 授权协议 **三勾**后方可确认 |
| 授权剩余天数 | 授权状态页醒目展示 + 续费 CTA |

---

## 5. 微信公众号登录（涨粉）与领证

- 管理端登录页「微信」按钮走 **公众号扫码授权**（`SocialType = 31`，`WECHAT_MP`）  
- **装机向导领证**复用同一 **守赚云** 公众号：官方 **带参数二维码**（未关注先关注；已关注 SCAN）  
  真源：[生成带参数的二维码](https://developers.weixin.qq.com/doc/service/api/qrcode/qrcodes/api_createqrcode.html) · [LICENSE-ISSUE-RUNBOOK](./LICENSE-ISSUE-RUNBOOK.md)  
- **勿**与企业微信 `30`、开放平台 App `32` 混用  
- 后台须配置：社交客户端 31 + **公众号服务器 URL**（`/admin-api/mp/open/{appId}` 收 subscribe/SCAN）+ `mp_account`  
- APP 会员端「公众号」入口走网页授权（同样 `type=31`），开放平台 App 登录仍为「微信」`type=32`

未配置 31 客户端或服务器 URL 时，装机二维码无法变 READY——属配置问题，非缺功能。

**运维步骤真源**：[SOCIAL-CLIENT-OAUTH-OPS.md](./SOCIAL-CLIENT-OAUTH-OPS.md)（含 SQL、抖音 60 / 快手 80）。

---

## 6. 支持

- 工单 / 邮箱：见购买合同或官方站点「支持」页  
- 升级：优先走应用市场签名更新；大版本按合同窗口  
- **框架本体升级**：控制面「框架与能力更新」发布 `component=backend`、`version=` 高于节点当前版本（节点 `reported_versions` / 装机 `frameworkVersion`）；勿与本 README 文档版本号（1.4.x）混淆

---

## 7. 变更记录

| 版本 | 日期 | 说明 |
|------|------|------|
| 1.4.13 | 2026-08-21 | 能力市场独占下单：后台去购买；Hub 为唯一下单面（微擎对标） |
| 1.4.12 | 2026-08-20 | 站点根 `/` 302→`/install` 或管理端（禁裸根 401 JSON） |
| 1.4.11 | 2026-08-20 | 续费引导改 Hub `open.zrlmeng.com/license/renew`（禁 www）；`YUDAO_LICENSE_RENEW_HINT_URL` 可覆盖；冒烟 `smoke-community-site-admin.py` |
| 1.4.10 | 2026-08-20 | §1.1 站长三入口（应用市场 / 授权状态 / 框架与能力更新）；菜单冲突安全 SQL |
| 1.4.9 | 2026-08-20 | 完成页：用户名/密码/后台地址支持「复制」与「保存到本地」凭证 txt |
| 1.4.8 | 2026-08-20 | 后台入口按规则高熵生成（`xxxxxx-xxxxxx-xxxxxx`）；向导可重新生成；未完成时自动升级旧 `mgmt-{8hex}` |
| 1.4.7 | 2026-08-20 | 同机嵌入完整 Vben 管理端；向导可改后台入口（默认 mgmt-xxxxxxxx）；`/admin-ui/` 仅 302；完成页展示入口 URL + 应用市场引导 |
| 1.4.6 | 2026-08-19 | 向导展示公众号微信号/AppID；完成时自动强密码写库；`/admin-ui/` 登录入口修复（禁跳 401 JSON） |
| 1.4.5 | 2026-08-19 | 激活成功后锁定授权码与节点编号，防用户误改 |
| 1.4.4 | 2026-08-19 | 节点编号系统自动生成、主界面只读；运维旁路才可改（行业惯例） |
| 1.4.3 | 2026-08-19 | 向导展示框架版本；install.lock / 交付包打 FRAMEWORK_VERSION；节点回报落盘 reported_versions |
| 1.4.2 | 2026-08-19 | install.sh：MySQL 空/弱口令自动强密码；Redis 密码可不配 |
| 1.4.1 | 2026-08-19 | 第 3 步显式 MySQL/Redis；推荐库名 shouzhuan_community |
| 1.4.0 | 2026-08-19 | 第 5 步微信扫码领免费框架证（守赚云）；完成页一次展示 admin 账密 |
| 1.3.1 | 2026-08-01 | 社交运维真源 [SOCIAL-CLIENT-OAUTH-OPS](./SOCIAL-CLIENT-OAUTH-OPS.md)（31/60/80 SQL） |
| 1.3.0 | 2026-08-01 | 微擎可参考项（状态分栏/更新三勾/剩余天数）；公众号登录 SocialType=31 |
| 1.2.0 | 2026-07-30 | License 控制面签发 + 加购确认单口径；Runbook 回链 |
| 1.1.0 | 2026-07-30 | `/install` 六步向导说明；库连接改为编排预配 + 连通确认 |
| 1.0.0 | 2026-07-30 | 首版站长说明（无内网泄漏） |


## 升级前备份（零丢数 · G0）

见 [FRAMEWORK-RELEASE-SOP.md](./FRAMEWORK-RELEASE-SOP.md)。
