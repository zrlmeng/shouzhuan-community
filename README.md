# 守赚开放平台 · 社区版

| 项 | 值 |
|----|-----|
| 产品 | 守赚开放平台 · 社区版 |
| 发行形态 | 商业发行包（enc） |
| 框架版本 | **1.0.2** |
| License | 须联网激活 |

本仓库提供社区版的安装说明与 Compose 模板。可运行制品请从 [Releases](../../releases) 下载 `ztdh-install-enc-*.tar.gz`，或使用 Docker Hub 镜像。

## 获取运行包

1. **GitHub / Gitee Release**：下载 `ztdh-install-enc-1.0.2.tar.gz`  
2. **Docker Hub**：`docker pull zhitongdaohe/shouzhuan-community:1.0.2`

校验（Windows PowerShell）：

```powershell
Get-FileHash .\ztdh-install-enc-1.0.2.tar.gz -Algorithm SHA256
# 期望：679ED057B6832E597E9FAD46CC89718644E6A83F1E1C49B816F2CC651A29E6DE
```

## 一键安装（Docker）

生产默认：`docker-compose.yml` = 应用容器 + 宿主机 MySQL / Redis。

```bash
tar -xzf ztdh-install-enc-1.0.2.tar.gz
cd ztdh-install-enc-1.0.2
cp .env.example .env
bash install.sh
# 浏览器打开 http://127.0.0.1:<APP_PORT>/install
# 完成向导后按页面提示完成联网激活
```

仅本地试用可用 `compose-poc-all-in-one.yml`；正式环境请使用生产默认编排，用户数据放在宿主机 MySQL / Redis。

## 激活与能力市场

1. `/install` 向导完成 → 生成 `install.lock`  
2. 联网完成 License 激活  
3. 垂直能力（如应用市场）可在能力市场按需加购；框架基础能力按产品说明提供  

文档：[docs.zrlmeng.com/community](https://docs.zrlmeng.com/community/)

## 镜像说明（Docker Hub）

```bash
docker pull zhitongdaohe/shouzhuan-community:1.0.2
```

拉取后按镜像说明或本仓 Compose 启动；启动后仍须完成联网激活。

## 相关链接

| 平台 | 地址 |
|------|------|
| GitHub | https://github.com/zrlmeng/shouzhuan-community |
| Gitee | https://gitee.com/zrlmeng/shouzhuan-community |
| Docker Hub | https://hub.docker.com/r/zhitongdaohe/shouzhuan-community |
| 帮助文档 | https://docs.zrlmeng.com/community/ |
