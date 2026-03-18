# K3s v1.35.0+k3s1 单机安装说明

K3s 是一个轻量级的 Kubernetes 发行版，专为边缘计算和资源受限环境设计。本文档提供 K3s 单机安装的详细步骤。

## 安装环境要求

- **操作系统**：Linux (Ubuntu, CentOS, RHEL, Debian 等)
- **内存**：至少 512MB（推荐 1GB 以上）
- **CPU**：至少 1 核
- **磁盘**：至少 1GB 可用空间
- **网络**：能够访问互联网

## 安装步骤

### 使用国内镜像源安装

执行以下命令安装 K3s v1.35.0+k3s1：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.35.0+k3s1 sh -
```

### 安装过程说明

1. 脚本会自动下载 K3s 二进制文件
2. 配置 systemd 服务
3. 启动 K3s 服务
4. 生成 kubeconfig 文件

## 验证安装

### 检查 K3s 服务状态

```bash
systemctl status k3s
```

### 检查 Kubernetes 集群状态

```bash
kubectl get nodes
```

输出类似：

```
NAME         STATUS   ROLES                  AGE   VERSION
server-name  Ready    control-plane,master   1m    v1.35.0+k3s1
```

### 检查 Pod 状态

```bash
kubectl get pods -A
```

## 常用命令

### 启动/停止/重启 K3s 服务

```bash
# 启动
systemctl start k3s

# 停止
systemctl stop k3s

# 重启
systemctl restart k3s
```

### 查看 K3s 日志

```bash
journalctl -u k3s -f
```

### 获取 kubeconfig 文件

K3s 会自动生成 kubeconfig 文件，位于：

```bash
/etc/rancher/k3s/k3s.yaml
```

可以将此文件复制到 `~/.kube/config` 目录，或通过环境变量指定：

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## 卸载 K3s

如果需要卸载 K3s，执行以下命令：

```bash
/usr/local/bin/k3s-uninstall.sh
```

## 自定义配置

### 修改安装参数

可以通过环境变量或命令行参数来自定义 K3s 安装：

```bash
# 禁用 traefik  ingress
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.35.0+k3s1 INSTALL_K3S_EXEC="--disable=traefik" sh -

# 指定 API 服务器端口
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.35.0+k3s1 INSTALL_K3S_EXEC="--https-listen-port=6443" sh -
```

### 配置文件

K3s 配置文件位于：

```bash
/etc/rancher/k3s/config.yaml
```

可以在此文件中添加自定义配置。

### 配置镜像源

K3s 使用 `registries.yaml` 文件配置镜像仓库镜像源，位于：

```bash
/etc/rancher/k3s/registries.yaml
```

如果文件不存在，可创建该文件并添加以下内容以使用国内镜像源：

```yaml
mirrors:
  docker.io:
    endpoint:
      - "https://docker.m.daocloud.io"
```

这样配置后，K3s 拉取 docker.io 镜像时会使用国内的 daocloud 镜像源，提高拉取速度。

## 常见问题

### 端口冲突

确保以下端口未被占用：

- 6443：Kubernetes API 服务器
- 8443：K3s 服务器
- 10250：Kubelet

### 防火墙设置

如果启用了防火墙，需要开放相关端口：

#### K3s 节点入站规则

| Protocol | Port | Source | Destination | Description |
|---------|------|--------|-------------|-------------|
| TCP | 2379-2380 | Servers | Servers | Required only for HA with embedded etcd（仅 HA 模式且使用嵌入式 etcd 时需要） |
| TCP | 6443 | Agents | Servers | K3s supervisor and Kubernetes API Server（K3s 监督器和 Kubernetes API 服务器） |
| UDP | 8472 | All nodes | All nodes | Required only for Flannel VXLAN（仅使用 Flannel VXLAN 网络时需要） |
| TCP | 10250 | All nodes | All nodes | Kubelet metrics（Kubelet 指标） |
| UDP | 51820 | All nodes | All nodes | Required only for Flannel Wireguard with IPv4（仅使用 Flannel Wireguard IPv4 网络时需要） |
| UDP | 51821 | All nodes | All nodes | Required only for Flannel Wireguard with IPv6（仅使用 Flannel Wireguard IPv6 网络时需要） |
| TCP | 5001 | All nodes | All nodes | Required only for embedded distributed registry (Spegel)（仅使用嵌入式分布式注册表 Spegel 时需要） |
| TCP | 6443 | All nodes | All nodes | Required only for embedded distributed registry (Spegel)（仅使用嵌入式分布式注册表 Spegel 时需要） |

```bash
# 对于 firewalld
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --reload

# 对于 iptables
sudo iptables -A INPUT -p tcp --dport 6443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 10250 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

### 资源不足

如果遇到内存不足的问题，可以调整 K3s 的内存限制：

在 `/etc/rancher/k3s/config.yaml` 中添加：

```yaml
kubelet-arg:
  - "--memory-manager-policy=Static"
  - "--kube-reserved=cpu=100m,memory=100Mi"
  - "--system-reserved=cpu=100m,memory=100Mi"
```

## 升级 K3s

要升级 K3s 到新版本，只需重新运行安装脚本并指定新版本：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=新版本号 sh -
```

## 参考资源

- [K3s 官方文档](https://docs.k3s.io/)
- [Rancher 镜像站](https://rancher-mirror.rancher.cn/)
- [K3s GitHub 仓库](https://github.com/k3s-io/k3s)

