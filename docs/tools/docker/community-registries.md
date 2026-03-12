# 社区与第三方公共镜像源

## 官方 Docker Hub

- **地址**：https://hub.docker.com/
- **特点**：
  - Docker 官方镜像仓库
  - 包含大量官方和社区镜像
  - 全球访问速度可能较慢

## 国内镜像源

### 阿里云 Docker 镜像

- **地址**：https://cr.console.aliyun.com/
- **特点**：
  - 国内访问速度快
  - 提供镜像加速服务
  - 支持私有镜像仓库

### 网易云镜像

- **地址**：https://c.163yun.com/hub
- **特点**：
  - 国内访问速度快
  - 提供免费的公共镜像

### 腾讯云镜像

- **地址**：https://cloud.tencent.com/product/tcr
- **特点**：
  - 国内访问速度快
  - 支持企业级镜像管理

### 轩辕镜像（免费版）

- **地址**：https://docker.xuanyuan.me
- **特点**：
  - 支持 13 种主流 Linux 发行版，包括国产操作系统
  - 内置多镜像源智能切换（阿里云、腾讯云、华为云、中科大、清华等）
  - 提供一键安装配置脚本，自动安装 docker 并配置镜像源
  - 支持老版本系统特殊处理
  - 双重安装保障，包管理器安装失败时自动切换到二进制安装

### DaoCloud

- **地址**：https://docker.m.daocloud.io
- **特点**：
  - 国内访问速度快
  - 提供免费的镜像加速服务
  - 支持多种编程语言和框架的镜像

## 社区镜像源

### Quay.io

- **地址**：https://quay.io/
- **特点**：
  - 由 CoreOS 维护
  - 专注于容器安全
  - 提供自动化构建服务

### GitHub Container Registry

- **地址**：https://ghcr.io/
- **特点**：
  - 与 GitHub 集成
  - 支持从 GitHub Actions 构建和推送镜像
  - 提供免费的公共镜像存储

## 配置镜像加速

### Docker 守护进程配置

在 `daemon.json` 文件中添加镜像源：

```json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "https://mirror.aliyun.com",
    "https://hub-mirror.c.163.com",
    "https://docker.xuanyuan.me",
    "https://docker.m.daocloud.io"
  ]
}
```

### 重启 Docker 服务

```bash
# Linux
sudo systemctl restart docker

# Windows (PowerShell)
Restart-Service Docker
```

## 常用命令

### 轩辕镜像一键安装配置脚本

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 登录镜像仓库

```bash
docker login registry.example.com
```

### 拉取镜像

```bash
# 从官方仓库拉取
docker pull ubuntu:latest

# 从指定仓库拉取
docker pull registry.example.com/ubuntu:latest
```

### 推送镜像

```bash
# 标记镜像
docker tag ubuntu:latest registry.example.com/ubuntu:latest

# 推送镜像
docker push registry.example.com/ubuntu:latest
```

## 最佳实践

1. **使用国内镜像源**：提高拉取速度
2. **定期更新镜像**：保持安全补丁最新
3. **使用固定版本标签**：避免因版本变化导致的问题
4. **合理使用私有仓库**：保护敏感镜像
5. **镜像扫描**：定期扫描镜像安全漏洞