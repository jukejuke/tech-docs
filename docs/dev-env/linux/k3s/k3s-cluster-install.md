# K3s v1.35.0+k3s1 3台服务器集群安装说明

本文档提供在 3 台服务器上安装 K3s v1.35.0+k3s1 高可用集群的详细步骤。

## 环境准备

### 服务器配置

| 服务器 | 角色 | IP 地址 | 配置 |
|--------|------|---------|------|
| server1 | 主节点1 | 192.168.1.101 | 2核4G 50G |
| server2 | 主节点2 | 192.168.1.102 | 2核4G 50G |
| server3 | 主节点3 | 192.168.1.103 | 2核4G 50G |

### 系统要求

- **操作系统**：Linux (Ubuntu 20.04+, CentOS 7+, RHEL 7+)
- **内存**：至少 2GB 每节点
- **CPU**：至少 2 核每节点
- **磁盘**：至少 50GB 可用空间每节点
- **网络**：所有节点之间网络互通
- **防火墙**：开放必要端口（6443, 8443, 10250）

### 防火墙配置

#### Ubuntu/Debian 系统

```bash
# 开放端口
sudo ufw allow 6443/tcp
sudo ufw allow 8443/tcp
sudo ufw allow 10250/tcp

# 查看防火墙状态
sudo ufw status

# 如果防火墙未启用，启用防火墙
sudo ufw enable
```

#### CentOS/RHEL 系统

```bash
# 开放端口
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp

# 重新加载防火墙规则
sudo firewall-cmd --reload

# 查看防火墙状态
sudo firewall-cmd --list-all
```

## 安装步骤

### 步骤 1：安装第一个主节点

在 server1 上执行以下命令：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.35.0+k3s1 sh -
```

### 步骤 2：获取节点令牌

在 server1 上执行以下命令获取节点令牌：

```bash
token=$(cat /var/lib/rancher/k3s/server/node-token)
echo $token
```

### 步骤 3：安装第二个主节点

在 server2 上执行以下命令，使用获取的令牌：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.35.0+k3s1 K3S_TOKEN="$token" K3S_URL="https://192.168.1.101:6443" sh -
```

### 步骤 4：安装第三个主节点

在 server3 上执行以下命令，使用相同的令牌：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.35.0+k3s1 K3S_TOKEN="$token" K3S_URL="https://192.168.1.101:6443" sh -
```

## 验证集群状态

### 检查所有节点状态

在任意节点上执行：

```bash
kubectl get nodes
```

输出类似：

```
NAME       STATUS   ROLES                  AGE     VERSION
server1    Ready    control-plane,master   10m     v1.35.0+k3s1
server2    Ready    control-plane,master   5m      v1.35.0+k3s1
server3    Ready    control-plane,master   2m      v1.35.0+k3s1
```

### 检查集群组件状态

```bash
kubectl get componentstatuses
```

### 检查 Pod 状态

```bash
kubectl get pods -A
```

## 高可用配置

### 配置负载均衡

为了实现完全的高可用性，建议配置一个负载均衡器来分发请求到三个主节点。

#### 使用 HAProxy 配置负载均衡

在负载均衡服务器上安装 HAProxy：

```bash
sudo apt install haproxy -y  # Ubuntu
sudo yum install haproxy -y  # CentOS
```

编辑 `/etc/haproxy/haproxy.cfg` 文件，添加以下配置：

```cfg
frontend kubernetes
    bind *:6443
    mode tcp
    option tcplog
    default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
    mode tcp
    option tcplog
    option tcp-check
    balance roundrobin
    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
    server server1 192.168.1.101:6443 check
    server server2 192.168.1.102:6443 check
    server server3 192.168.1.103:6443 check
```

重启 HAProxy 服务：

```bash
sudo systemctl restart haproxy
sudo systemctl enable haproxy
```

### 集群可用性说明

#### 节点停机时的集群状态

在 K3s 高可用集群中，由于使用了 etcd 分布式数据库，集群的可用性取决于 etcd 的法定人数（quorum）。对于 3 节点集群：

- **当 1 个节点停机**：集群仍然可以正常运行，因为剩余 2 个节点满足 etcd 的法定人数要求（超过半数）。
- **当 2 个节点停机**：集群将失去 etcd 法定人数，无法正常工作，直到至少有 2 个节点恢复运行。

#### 验证集群在节点停机时的可用性

1. **模拟节点停机**：在任意主节点上执行关机或停止 K3s 服务：
   ```bash
   # 停止 K3s 服务
   systemctl stop k3s
   ```

2. **验证集群状态**：在正常运行的节点上执行：
   ```bash
   # 查看节点状态
   kubectl get nodes
   # 查看集群组件状态
   kubectl get componentstatuses
   # 查看 Pod 状态
   kubectl get pods -A
   ```

3. **验证服务可用性**：部署一个测试 Pod 并访问其服务，确保集群仍能正常处理请求。

#### 维护最佳实践

- **滚动维护**：每次只维护一个节点，确保至少有 2 个节点保持运行状态。
- **备份数据**：在进行维护前，执行 etcd 数据备份，以防万一。
- **监控集群**：使用监控工具（如 Prometheus）监控集群状态，及时发现节点故障。

### 更新 kubeconfig 文件

使用负载均衡器的 IP 地址更新 kubeconfig 文件：

```bash
# 复制 kubeconfig 文件
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

# 编辑文件，将 server 地址改为负载均衡器地址
sed -i 's/127.0.0.1:6443/负载均衡器IP:6443/g' ~/.kube/config
```

## 常用命令

### 集群管理

```bash
# 查看集群信息
kubectl cluster-info

# 查看节点详情
kubectl describe nodes

# 查看所有命名空间
kubectl get namespaces

# 查看所有 Pod
kubectl get pods --all-namespaces
```

### 服务管理

```bash
# 启动/停止/重启 K3s 服务
# 在每个节点上执行
systemctl start k3s
systemctl stop k3s
systemctl restart k3s

# 查看 K3s 日志
journalctl -u k3s -f
```

### 备份与恢复

```bash
# 备份 etcd 数据
k3s etcd-snapshot save --name snapshot-$(date +%Y%m%d)

# 恢复 etcd 数据
k3s server --cluster-reset --cluster-reset-restore-path=/path/to/snapshot
```

## 故障排查

### 节点无法加入集群

1. **检查网络连接**：确保节点之间网络互通
2. **检查令牌是否正确**：验证令牌是否过期或错误
3. **检查防火墙设置**：确保端口 6443 开放
4. **查看日志**：`journalctl -u k3s -f`

### Pod 状态异常

1. **查看 Pod 日志**：`kubectl logs <pod-name> -n <namespace>`
2. **查看 Pod 描述**：`kubectl describe pod <pod-name> -n <namespace>`
3. **检查资源使用**：`kubectl top nodes`

### 集群无法访问

1. **检查负载均衡器状态**：`systemctl status haproxy`
2. **检查主节点状态**：`systemctl status k3s`
3. **检查 API 服务器**：`curl -k https://localhost:6443/healthz`

## 升级集群

### 升级所有节点

1. **升级第一个主节点**：
   ```bash
   curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=新版本号 sh -
   ```

2. **升级其他主节点**：
   ```bash
   curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=新版本号 K3S_TOKEN="$token" K3S_URL="https://192.168.1.101:6443" sh -
   ```

## 卸载集群

### 卸载所有节点

在每个节点上执行：

```bash
/usr/local/bin/k3s-uninstall.sh
```

## 参考资源

- [K3s 官方高可用文档](https://docs.k3s.io/installation/ha)
- [Rancher 镜像站](https://rancher-mirror.rancher.cn/)
- [K3s GitHub 仓库](https://github.com/k3s-io/k3s)
- [HAProxy 官方文档](https://www.haproxy.com/documentation/)
