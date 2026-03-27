# Docker 安装文档

## 1. Docker 简介

Docker 是一个开源的容器化平台，允许开发者打包、分发和运行应用程序及其依赖项。它使用容器技术，提供了一种轻量级、可移植的方式来部署应用程序。

### 主要优势

- **隔离性**：容器之间相互隔离，避免依赖冲突
- **轻量级**：容器共享主机内核，比虚拟机更高效
- **可移植性**：容器可以在任何支持 Docker 的环境中运行
- **一致性**：确保开发、测试和生产环境的一致性
- **快速部署**：容器启动速度快，适合微服务架构

## 2. 系统要求

### Windows

- Windows 10 64位：专业版、企业版或教育版（Build 15063 或更高版本）
- Windows 11 64位：专业版、企业版或教育版
- 至少 4GB 内存
- 启用 Hyper-V 和容器功能

### Linux

- 64位 Linux 操作系统
- 内核版本 3.10 或更高
- 至少 2GB 内存
- 足够的磁盘空间（建议至少 20GB）

### macOS

- macOS 10.15 (Catalina) 或更高版本
- 至少 4GB 内存
- 足够的磁盘空间（建议至少 20GB）

## 3. Windows 安装步骤

### 方法 1：使用 Docker Desktop for Windows

1. **下载安装包**
   - 访问 [Docker Desktop 官方下载页面](https://www.docker.com/products/docker-desktop)
   - 下载适用于 Windows 的安装程序

2. **安装 Docker Desktop**
   - 双击下载的安装程序
   - 按照安装向导的提示完成安装
   - 安装过程中会自动启用 Hyper-V 和容器功能

3. **启动 Docker Desktop**
   - 安装完成后，启动 Docker Desktop
   - 接受服务条款
   - 等待 Docker 引擎启动

4. **验证安装**
   - 打开 PowerShell 或命令提示符
   - 运行以下命令：
     ```powershell
     docker --version
     docker run hello-world
     ```

### 方法 2：使用 Windows Subsystem for Linux (WSL 2)

1. **启用 WSL 2**
   - 以管理员身份打开 PowerShell
   - 运行以下命令：
     ```powershell
     wsl --install
     ```
   - 重启计算机

2. **安装 Docker Desktop**
   - 下载并安装 Docker Desktop
   - 在设置中启用 WSL 2 集成

3. **验证安装**
   - 打开 WSL 终端
   - 运行以下命令：
     ```bash
     docker --version
     docker run hello-world
     ```

## 4. Linux 安装步骤

### Ubuntu/Debian 系统

1. **更新系统**
   ```bash
   sudo apt-get update
   sudo apt-get upgrade -y
   ```

2. **安装依赖包**
   ```bash
   sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
   ```

3. **添加 Docker GPG 密钥**
   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   ```

4. **添加 Docker 仓库**
   ```bash
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   ```

5. **安装 Docker**
   ```bash
   sudo apt-get update
   sudo apt-get install -y docker-ce docker-ce-cli containerd.io
   ```

6. **启动并启用 Docker 服务**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

7. **验证安装**
   ```bash
   docker --version
   sudo docker run hello-world
   ```

8. **（可选）将用户添加到 docker 组**
   ```bash
   sudo usermod -aG docker $USER
   ```
   然后注销并重新登录以应用更改

### CentOS/RHEL 系统

1. **更新系统**
   ```bash
   sudo yum update -y
   ```

2. **安装依赖包**
   ```bash
   sudo yum install -y yum-utils device-mapper-persistent-data lvm2
   ```

3. **添加 Docker 仓库**
   ```bash
   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   ```

4. **安装 Docker**
   ```bash
   sudo yum install -y docker-ce docker-ce-cli containerd.io
   ```

5. **启动并启用 Docker 服务**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

6. **验证安装**
   ```bash
   docker --version
   sudo docker run hello-world
   ```

7. **（可选）将用户添加到 docker 组**
   ```bash
   sudo usermod -aG docker $USER
   ```
   然后注销并重新登录以应用更改

### 使用轩辕镜像一键安装脚本

对于 Linux 系统，也可以使用轩辕镜像提供的一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

## 5. macOS 安装步骤

1. **下载安装包**
   - 访问 [Docker Desktop 官方下载页面](https://www.docker.com/products/docker-desktop)
   - 下载适用于 macOS 的安装程序

2. **安装 Docker Desktop**
   - 双击下载的 `.dmg` 文件
   - 将 Docker 图标拖放到 Applications 文件夹中
   - 打开 Applications 文件夹并启动 Docker

3. **启动 Docker Desktop**
   - 首次启动时，会提示您输入管理员密码
   - 接受服务条款
   - 等待 Docker 引擎启动

4. **验证安装**
   - 打开终端
   - 运行以下命令：
     ```bash
     docker --version
     docker run hello-world
     ```

## 6. 安装后的配置

### 配置镜像加速

为了提高 Docker 镜像的拉取速度，建议配置镜像加速源。

#### Windows/macOS

1. 打开 Docker Desktop 设置
2. 进入 Docker Engine 选项卡
3. 在配置文件中添加镜像源：
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
4. 点击应用并重启 Docker

#### Linux

1. 创建或编辑 `/etc/docker/daemon.json` 文件：
   ```bash
   sudo nano /etc/docker/daemon.json
   ```

2. 添加以下内容：
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

3. 保存文件并重启 Docker 服务：
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart docker
   ```

### 验证镜像加速配置

运行以下命令验证镜像加速是否配置成功：

```bash
docker info
```

在输出中查找 `Registry Mirrors` 部分，确认配置的镜像源已生效。

## 7. 常用 Docker 命令

### 基本命令

| 命令 | 描述 | 示例 |
|------|------|------|
| `docker --version` | 查看 Docker 版本 | `docker --version` |
| `docker info` | 查看 Docker 系统信息 | `docker info` |
| `docker run` | 运行容器 | `docker run hello-world` |
| `docker ps` | 查看正在运行的容器 | `docker ps` |
| `docker ps -a` | 查看所有容器（包括已停止的） | `docker ps -a` |
| `docker images` | 查看本地镜像 | `docker images` |
| `docker pull` | 拉取镜像 | `docker pull ubuntu:latest` |
| `docker build` | 构建镜像 | `docker build -t myapp .` |
| `docker stop` | 停止容器 | `docker stop container_id` |
| `docker rm` | 删除容器 | `docker rm container_id` |
| `docker rmi` | 删除镜像 | `docker rmi image_id` |

### 高级命令

| 命令 | 描述 | 示例 |
|------|------|------|
| `docker exec` | 在运行的容器中执行命令 | `docker exec -it container_id bash` |
| `docker logs` | 查看容器日志 | `docker logs container_id` |
| `docker inspect` | 查看容器详细信息 | `docker inspect container_id` |
| `docker network ls` | 查看网络 | `docker network ls` |
| `docker volume ls` | 查看卷 | `docker volume ls` |
| `docker-compose up` | 启动 Compose 服务 | `docker-compose up -d` |
| `docker-compose down` | 停止 Compose 服务 | `docker-compose down` |

## 8. 故障排除

### 常见问题及解决方案

#### 1. Docker 服务无法启动

**症状**：Docker 服务启动失败，或者 Docker Desktop 显示启动错误。

**解决方案**：
- 检查系统是否满足 Docker 的最低要求
- 确保 Hyper-V（Windows）或虚拟化技术（Linux/macOS）已启用
- 检查防火墙设置是否阻止了 Docker 相关端口
- 查看 Docker 日志以获取详细错误信息

#### 2. 镜像拉取速度慢

**症状**：拉取 Docker 镜像时速度非常慢，甚至超时。

**解决方案**：
- 配置镜像加速源（详见第 6 节）
- 尝试使用不同的镜像源
- 检查网络连接是否稳定

#### 3. 容器运行失败

**症状**：容器启动后立即退出，或者运行时出现错误。

**解决方案**：
- 查看容器日志：`docker logs container_id`
- 检查容器的环境变量和配置
- 确保容器所需的端口未被占用
- 检查容器的资源限制是否合理

#### 4. 权限问题

**症状**：执行 Docker 命令时出现权限错误。

**解决方案**：
- 在 Linux 上，确保当前用户已添加到 docker 组
- 在 Windows/macOS 上，确保以管理员/root 权限运行命令
- 检查文件和目录的权限设置

#### 5. Docker 空间不足

**症状**：Docker 提示磁盘空间不足，无法拉取或构建镜像。

**解决方案**：
- 清理未使用的镜像：`docker image prune`
- 清理未使用的容器：`docker container prune`
- 清理未使用的卷：`docker volume prune`
- 清理所有未使用的资源：`docker system prune`

## 9. 最佳实践

1. **使用官方镜像**：优先使用 Docker Hub 上的官方镜像
2. **使用固定版本标签**：避免使用 `latest` 标签，使用具体版本号
3. **定期更新镜像**：保持镜像和容器的安全补丁最新
4. **使用多阶构建**：减小镜像大小，提高安全性
5. **合理使用资源限制**：为容器设置适当的 CPU 和内存限制
6. **使用 Docker Compose**：管理多容器应用程序
7. **定期备份数据**：使用卷或绑定挂载来持久化数据
8. **镜像扫描**：定期扫描镜像中的安全漏洞
9. **使用私有仓库**：对于敏感应用，使用私有镜像仓库
10. **文档化配置**：记录 Dockerfile 和配置文件的变更

## 10. 参考资源

- [Docker 官方文档](https://docs.docker.com/)
- [Docker 官方 GitHub 仓库](https://github.com/docker/docker-ce)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [Docker 最佳实践](https://docs.docker.com/develop/dev-best-practices/)

## 11. 版本兼容性矩阵

| Docker 版本 | 支持的操作系统版本 |
|------------|-------------------|
| Docker Desktop 4.20+ | Windows 10/11 (64位)，macOS 12+ |
| Docker Engine 24.0+ | Ubuntu 20.04+，Debian 11+，CentOS 8+，RHEL 8+ |
| Docker Engine 20.10+ | Ubuntu 18.04+，Debian 10+，CentOS 7+，RHEL 7+ |

## 12. 常见错误代码及解决方案

| 错误代码 | 描述 | 解决方案 |
|---------|------|----------|
| `Cannot connect to the Docker daemon` | 无法连接到 Docker 守护进程 | 检查 Docker 服务是否运行 |
| `No space left on device` | 设备空间不足 | 清理 Docker 资源 |
| `port is already allocated` | 端口已被占用 | 使用不同的端口或停止占用该端口的进程 |
| `image not found` | 镜像未找到 | 确保镜像名称正确，或先拉取镜像 |
| `permission denied` | 权限被拒绝 | 确保用户有足够的权限，或使用 sudo |

## 13. 安装验证

### 基本验证

运行以下命令验证 Docker 安装是否成功：

```bash
# 查看 Docker 版本
docker --version

# 运行 hello-world 容器
docker run hello-world

# 查看本地镜像
docker images

# 查看所有容器
docker ps -a
```

### 功能验证

```bash
# 构建一个简单的镜像
echo 'FROM alpine:latest
RUN echo "Hello, Docker!" > /hello.txt
CMD cat /hello.txt' > Dockerfile
docker build -t test-image .

# 运行构建的镜像
docker run test-image

# 清理测试资源
docker rm $(docker ps -aq)
docker rmi test-image
rm Dockerfile
```

如果所有命令都能正常执行，说明 Docker 安装成功并可以正常工作。