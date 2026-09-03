# 守赚开放平台 · 社区版（基础框架）

> 宝塔应用市场 / 站长源码站 上架描述模板 · 随 `product-manifest.yaml` 版本更新

## 产品名称

守赚开放平台 · 社区版（可自托管商业框架）

> 站长源码 / 宝塔上架对外主名：**社区版**（旧称「装机版」已废）。

## 一句话

**一套可自托管的基础框架 + 内置能力市场**（默认 **商业发行包**；过审可用 **审计源码包**）；增长激励、天气、浏览器、问卷、**应用商店产品线** 等 **不打进默认发行包**，与 **官方能力市场同步**，按需购买安装。License **必须联网**（授权=续费主轴）。

## 包含（标准发行范围）

- 多租户运行底座（企业级 Java 单体 + MySQL 8）
- 租户管理后台 + **能力市场入口**
- 用户/登录/首页/消息等 **共享基础模块**
- 跨端应用壳层模板
- License 联网激活 · 签名更新通道

## 不包含（需在市场安装）

- 应用商店产品线、增长激励、浏览器、天气、问卷等 **产品模块**
- 上述能力从 **官方能力市场** 浏览、购买、下载；**目录与主站同步**
- **≠** 把平台商业核心源码打进默认发行包（见双版本 / 授权防破解专文）

## 环境要求

- JDK 25 运行环境（Docker 镜像已含 JRE）
- MySQL 8.4 · Redis
- 宝塔 7.x+ 或 Docker Compose
- 服务器需 **出站 HTTPS** 访问官方主站（License + 应用市场）
- 阿里云云市场镜像：买 ECS 选本镜像即可；License **开机自动领取框架免费证**（仍须联网，垂直模块仍加购）

## 安装

1. 上传安装包 / 导入宝塔应用（或云市场选镜像开 ECS）  
2. 访问 `/install` 完成六步初始化（第 4 步确认**强密码**与**可改后台入口路径**）  
3. 激活 License：宝塔/源码站 **微信扫码领取**或填写激活码；阿里云镜像 **开机自动领取框架免费证**（无需手填）  
4. 打开向导给出的管理端 URL（如 `/a3f8k9-m2xq7n-4bp8c1/`）登录完整后台 → 侧栏 **应用市场** → 按需安装能力  
   - 旧 `/admin-ui/` 会跳转到当前入口；勿依赖全网雷同默认路径 

## 声明

- 本包为 **签名运行时 / 审计薄源**（按发行形态），不含平台授权中心签发与上架管理源码  
- 禁止移除 License 校验与版权信息  

## 官方支持

| 渠道 | 联系 |
|------|------|
| 官网支持 | https://www.zrlmeng.com/support |
| 工单 / 邮件 | support@zrlmeng.com |
| 预发演示（非生产） | https://install-staging.zrlmeng.com/ |

Docker Hub 镜像：https://hub.docker.com/r/zhitongdaohe/shouzhuan-community  
更多说明见仓库根目录 [README.md](../README.md)。

## 交付包体积（商6）

| 项 | 值 |
|----|-----|
| 现状（2026-07-31 enc/oss） | ~244MB（`ztdh-*-20260731.tar.gz`；②/③×enc/oss） |
| 对照（2026-07-30 enc） | ~338MB |
| **过渡门槛** `max_enc_tar_mb` | **400**（本波**不瘦包**） |
| **目标门槛** `target_enc_tar_mb` | **280**（瘦身 Sprint DoD；见 [体积策略](./DELIVERY-PACKAGE-SIZE-STRATEGY.md)） |
| 门禁 | `python products/install/scripts/check-install-package-size.py` |
| 宝塔过审 | §C2 另项；瘦身后再冲渠道上传上限 |

> 真源：[`product-manifest.yaml`](./product-manifest.yaml) `delivery.*` · 策略专文 [DELIVERY-PACKAGE-SIZE-STRATEGY](./DELIVERY-PACKAGE-SIZE-STRATEGY.md)。

## 应用市场 · SKU 与主站同步

| 项 | 说明 |
|----|------|
| 目录真源 | 官方主站能力目录（71 §3） |
| standalone 行为 | **只读同步** · 不可私自上架 |
| 同步策略 | 15min + 打开市场页强制刷新 — [remote_market §3](../../docs/platform/delivery/remote_market租户应用市场闭环.md) |
| 已购保留 | 主站下架 SKU 后，已购 Grant **保留至到期** |
| **目录分组** | 装机已含 / 壳与触达 / **专区加购**（contact · invite · staff · **growth.ops**）/ 独立垂直 / 即将上架 — 见 [甲方交付说明 §2.1](../../docs/platform/delivery/公共能力与垂直能力包-甲方交付说明.md) |
| **专区 SKU** | `contact.channels` ¥99/年 · `promotion.invite` ¥199/年 · `staff.zone` ¥299/年 · **`growth.ops`** ¥399/年（积分+福利+限时+互动四区组合） |
| **壳与触达加购** | **`runtime.app_identity.extra_slot`** ¥199/年 — 同款 APP 种类 **+1** 套名称+包名（每垂直默认各 1 槽；第二款须加购） |
| 消歧 | `earn.core` · `appmarket.core` ∈ **独立垂直**；赚钱区 ≠ 守赚垂直 |
