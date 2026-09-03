# 守赚开放平台 · 社区版（商业发行包）

| 项 | 值 |
|----|-----|
| 产品 | 守赚开放平台 · 社区版 |
| 发行形态 | **enc**（商业发行包 · **零业务源码**） |
| 框架版本 | **1.0.2** |
| License | **必须联网激活**（无离线宽限） |

> 本仓库是 **独立发行仓**，只提供安装说明与 Compose 模板。  
> **业务实现源码永不公开。** 可运行制品请从 [Releases](../../releases) 下载 `ztdh-install-enc-*.tar.gz`，或使用 Docker Hub 镜像。

## 获取运行包

1. **GitHub / Gitee Release**：下载 `ztdh-install-enc-1.0.2.tar.gz`（仅此包名；勿使用其它 SKU）  
2. **Docker Hub**：`docker pull zhitongdaohe/shouzhuan-community:1.0.2`

校验（Windows PowerShell）：

```powershell
Get-FileHash .\ztdh-install-enc-1.0.2.tar.gz -Algorithm SHA256
# 期望：E40CA6A3ADF4FF0437F76B3C8E5CB542DBE7844D83D338F50EA8459FDCF4507C
```

## 一键安装（Docker）

生产默认：`docker-compose.yml` = 应用容器 + **宿主机 MySQL / Redis**（用户数据不放可丢的 Docker 卷）。

```bash
tar -xzf ztdh-install-enc-1.0.2.tar.gz
cd ztdh-install-enc-1.0.2
cp .env.example .env
bash install.sh
# 浏览器打开 http://127.0.0.1:<APP_PORT>/install
# 完成向导后填写激活码（须出站 HTTPS 联网）
```

仅本地 PoC 可用 `compose-poc-all-in-one.yml`；**禁止**用 PoC 承载真实用户数据。

## 激活与能力市场

1. `/install` 向导完成 → 生成 `install.lock`  
2. **联网** License 激活（租户 Grant）  
3. 垂直能力（应用市场等）在能力市场加购，框架本身 ¥0  

文档：[docs.zrlmeng.com/community](https://docs.zrlmeng.com/community/)

## 镜像说明（Docker Hub）

```bash
docker pull zhitongdaohe/shouzhuan-community:1.0.2
```

镜像内为 JRE + 运行时 fat JAR，**不含**业务源码树。启动后仍须联网激活。

## 禁止事项（护城河）

- 本仓 **不会** 也不应出现母版工程源码、业务 `.java` / `.kt` 实现树  
- **禁止** 把万能激活码、私钥、生产 `.env` 提交到本仓  
- **禁止** 关闭联网 License 出厂  

## 相关链接

| 平台 | 地址 |
|------|------|
| GitHub | https://github.com/zrlmeng/shouzhuan-community |
| Gitee | https://gitee.com/zrlmeng/shouzhuan-community |
| Docker Hub | https://hub.docker.com/r/zhitongdaohe/shouzhuan-community |
| 帮助文档 | https://docs.zrlmeng.com/community/ |

---

© 山西智同道合科技有限公司
