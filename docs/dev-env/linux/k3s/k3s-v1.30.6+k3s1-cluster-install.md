# K3s v1.30.6+k3s1 3台主节点高可用集群安装说明

## 环境准备

### 服务器配置要求

| 服务器角色        | 数量 | CPU | 内存   | 存储    | 网络    |
| ------------ | -- | --- | ---- | ----- | ----- |
| 主节点 (Server) | 3  | 2核+ | 2GB+ | 20GB+ | 局域网互通 |

### 操作系统要求

- Ubuntu 20.04 LTS 或更高版本
- Debian 10 或更高版本
- CentOS 7 或更高版本
- RHEL 7 或更高版本

### 网络要求

- 所有节点之间需要网络互通
- 所有主节点需要开放以下端口：

| 端口 | 协议 | 用途 |
| --- | --- | --- |
| 2379/tcp | TCP | etcd 客户端通信 |
| 2380/tcp | TCP | etcd 集群间通信 |
| 6443/tcp | TCP | Kubernetes API |
| 8472/udp | UDP | Flannel VXLAN |
| 10250/tcp | TCP | Kubelet |
| 30000-32767/tcp | TCP | NodePort 服务端口范围 |

**开放端口说明**：
- 这些端口是 K3s 集群正常运行所必需的
- 确保在所有主节点之间这些端口可互相访问
- 如果启用了防火墙，需要在防火墙规则中开放这些端口

## 安装步骤

### 1. 准备服务器

#### 1.1 设置主机名

在每个节点上设置唯一的主机名：

```bash
# 主节点1
sudo hostnamectl set-hostname k3s-server1

# 主节点2
sudo hostnamectl set-hostname k3s-server2

# 主节点3
sudo hostnamectl set-hostname k3s-server3
```

#### 1.2 配置 hosts 文件

在所有节点上编辑 `/etc/hosts` 文件，添加所有节点的IP地址和主机名：

```bash
sudo nano /etc/hosts
```

添加以下内容（根据实际IP地址修改）：

```
192.168.1.100 k3s-server1
192.168.1.101 k3s-server2
192.168.1.102 k3s-server3
```

#### 1.3 关闭防火墙（可选）

如果服务器启用了防火墙，需要开放相关端口或暂时关闭防火墙：

**开放端口脚本**：

```bash
# CentOS/RHEL
firewall-cmd --permanent --add-port=2379/tcp
firewall-cmd --permanent --add-port=2380/tcp
firewall-cmd --permanent --add-port=6443/tcp #apiserver
firewall-cmd --permanent --add-port=8472/udp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp #NodePort 服务端口范围
firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 #pods
firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 #services
firewall-cmd --reload
# 查看开放端口
firewall-cmd --list-ports

# Ubuntu/Debian
ufw allow 2379/tcp
ufw allow 2380/tcp
ufw allow 6443/tcp #apiserver
ufw allow 8472/udp
ufw allow 10250/tcp
ufw allow 30000:32767/tcp #NodePort 服务端口范围
ufw allow from 10.42.0.0/16 to any #pods
ufw allow from 10.43.0.0/16 to any #services
ufw reload
# 查看开放端口
ufw status
```

**或者暂时关闭防火墙**：

```bash
# Ubuntu/Debian
sudo ufw disable

# CentOS/RHEL
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

### 2. 安装第一个主节点

在第一个主节点上执行以下命令安装 K3s v1.30.6+k3s1 并初始化集群：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.30.6+k3s1 sh -s - server --cluster-init
```

安装完成后，验证主节点状态：

```bash
sudo systemctl status k3s
```

### 3. 获取节点加入令牌

在第一个主节点上执行以下命令获取其他主节点加入集群的令牌：

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

保存输出的令牌，稍后将用于其他主节点加入集群。

### 4. 安装其他主节点

在第二个和第三个主节点上执行以下命令，使用上一步获取的令牌加入集群：

```bash
# 主节点2
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.30.6+k3s1 K3S_URL=https://k3s-server1:6443 K3S_TOKEN=<TOKEN> sh -s - server

# 主节点3
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.30.6+k3s1 K3S_URL=https://k3s-server1:6443 K3S_TOKEN=<TOKEN> sh -s - server
```

**注意**：将 `<TOKEN>` 替换为实际的节点令牌。

### 5. 验证集群状态

在任意主节点上执行以下命令验证集群状态：

```bash
sudo kubectl get nodes
```

预期输出应该显示所有3个主节点，状态为 `Ready`：

```
NAME          STATUS   ROLES                  AGE     VERSION
k3s-server1   Ready    control-plane,master   10m     v1.30.6+k3s1
k3s-server2   Ready    control-plane,master   5m      v1.30.6+k3s1
k3s-server3   Ready    control-plane,master   3m      v1.30.6+k3s1
```

### 6. 验证 etcd 集群状态

执行以下命令验证 etcd 集群状态：

```bash
sudo kubectl get pods -n kube-system | grep etcd
```

所有 etcd  pods 应该处于 `Running` 状态。

### 7. 验证集群组件

执行以下命令验证集群组件状态：

```bash
sudo kubectl get pods -A
```

所有组件应该处于 `Running` 状态。

## 高可用集群特性

### 负载均衡配置（可选）

为了实现真正的高可用，建议在集群前面配置负载均衡器，将流量分发到各个主节点。可以使用 HAProxy、Nginx 等作为负载均衡器。

#### 示例 HAProxy 配置

```
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000
    timeout client 50000
    timeout server 50000

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
    server k3s-server1 192.168.1.100:6443 check
    server k3s-server2 192.168.1.101:6443 check
    server k3s-server3 192.168.1.102:6443 check
```

### 故障转移测试

可以通过停止其中一个主节点的 k3s 服务来测试集群的故障转移能力：

```bash
# 在其中一个主节点上执行
sudo systemctl stop k3s

# 在另一个主节点上验证集群状态
sudo kubectl get nodes
```

集群应该仍然正常运行，只是停止的节点状态会变为 `NotReady`。

## 常见问题排查

### 1. 节点无法加入集群

- 检查网络连接：确保所有节点之间网络互通，特别是 etcd 所需的 2379-2380 端口
- 检查令牌是否正确：重新获取并使用正确的令牌
- 检查防火墙设置：确保相关端口已开放（TCP 6443、UDP 8472、TCP 2379-2380）
- 检查 etcd 状态：确保 etcd 集群正常运行
- 检查主机名解析：确保所有节点的主机名都能正确解析
- 检查时间同步：确保所有节点的系统时间同步
- 查看详细日志：`sudo journalctl -u k3s` 查看完整的错误信息

### 2. 节点状态为 NotReady

- 检查 k3s 服务状态：`sudo systemctl status k3s`
- 检查日志：`sudo journalctl -u k3s`
- 检查网络插件：确保 Flannel 网络正常运行
- 检查 etcd 状态：`sudo kubectl get pods -n kube-system | grep etcd`

### 3. 集群组件异常

- 查看组件日志：`sudo kubectl logs -n kube-system <pod-name>`
- 重启 k3s 服务：`sudo systemctl restart k3s`
- 检查 etcd 集群健康状态：`sudo kubectl exec -n kube-system etcd-k3s-server1 -- etcdctl endpoint health --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key`

### 4. etcd 集群故障排查

如果遇到 etcd 集群相关错误（如 "runtime core not ready" 或 "apiserver not ready"）：

1. **检查 etcd 端口是否开放**：确保所有节点的 2379-2380 端口可互相访问
   ```bash
   # 在每个节点上执行
   sudo netstat -tuln | grep 2379
   sudo netstat -tuln | grep 2380
   ```

2. **检查 etcd 集群状态**：在第一个主节点上执行
   ```bash
   sudo kubectl exec -n kube-system etcd-k3s-server1 -- etcdctl member list --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key
   ```

3. **重新加入节点**：如果节点加入失败，可以尝试以下步骤
   - 停止 k3s 服务：`sudo systemctl stop k3s`
   - 清理 etcd 数据：`sudo rm -rf /var/lib/rancher/k3s/server/db/etcd`
   - 重新执行安装命令

4. **检查系统时间同步**：etcd 集群要求节点间时间同步
   ```bash
   # 安装并配置时间同步
   sudo apt install ntp -y  # Ubuntu/Debian
   sudo yum install ntp -y  # CentOS/RHEL
   sudo systemctl enable ntpd
   sudo systemctl start ntpd
   ```

## 卸载 K3s

在每个主节点上执行以下命令卸载 K3s：

```bash
sudo /usr/local/bin/k3s-uninstall.sh
```

## 升级 K3s

### 升级主节点

按照以下顺序升级主节点：

1. 升级第一个主节点：
   ```bash
   curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.30.6+k3s1 sh -
   ```
2. 升级其他主节点：
   ```bash
   curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.30.6+k3s1 K3S_URL=https://k3s-server1:6443 K3S_TOKEN=<TOKEN> sh -s - server
   ```

## 相关资源

- [K3s 官方文档](https://docs.k3s.io/)
- [K3s 高可用配置](https://docs.k3s.io/installation/ha)
- [Kubernetes 官方文档](https://kubernetes.io/docs/)
- [Flannel 网络插件](https://github.com/flannel-io/flannel)

## 配置镜像源

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

## 示例应用部署

参考 `examples` 目录下的示例文件，部署一个 Nginx 应用：

```bash
# 部署 Nginx 应用
sudo kubectl apply -f examples/nginx-deployment.yaml
sudo kubectl apply -f examples/nginx-service.yaml

# 查看部署状态
sudo kubectl get pods
sudo kubectl get services
```

## MetalLB 配置（替代 klipper-lb）

K3s 默认使用 klipper-lb 作为 LoadBalancer 实现，但它会使用节点的 IP 地址。如果需要使用独立的 IP 地址作为 LoadBalancer 地址，可以部署 MetalLB。

### 处理已安装的 klipper-lb

如果在安装 K3s 时没有排除 klipper-lb，后续仍然可以部署 MetalLB。两者可以共存，但 MetalLB 会优先处理 LoadBalancer 类型的服务。

#### 验证 klipper-lb 状态

```bash
# 查看 klipper-lb 组件状态
sudo kubectl get pods -n kube-system | grep klipper
```

#### 部署 MetalLB

即使 klipper-lb 存在，仍然可以按照以下步骤部署 MetalLB。当创建 LoadBalancer 类型的服务时，MetalLB 会接管并分配 IP 地址，而不是使用 klipper-lb。

#### 禁用 klipper-lb（可选）

如果希望完全禁用 klipper-lb，可以通过修改 K3s 配置来实现：

1. 编辑 K3s 配置文件：

```bash
sudo nano /etc/rancher/k3s/config.yaml
```

2. 添加以下内容：

```yaml
disable: klipper-lb
```

3. 重启 K3s 服务：

```bash
sudo systemctl restart k3s
```

4. 验证 klipper-lb 是否已被禁用：

```bash
sudo kubectl get pods -n kube-system | grep klipper
```

如果没有输出，说明 klipper-lb 已被成功禁用。

### 1. 安装 MetalLB

在任意主节点上执行以下命令安装 MetalLB：

```bash
# 安装 MetalLB
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
```

### 2. 配置 MetalLB IP 地址池

创建 MetalLB 配置文件，定义 IP 地址池：

```bash
sudo nano metallb-config.yaml
```

添加以下内容（根据实际网络环境修改 IP 地址范围）：

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.200-192.168.1.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default
```

应用配置：

```bash
sudo kubectl apply -f metallb-config.yaml
```

### 重新部署说明

如果已经部署了 MetalLB 并且需要更新配置，按照以下步骤操作：

1. **更新配置文件**：修改 `metallb-config.yaml` 文件中的配置内容（如 IP 地址范围、保留 IP 等）

2. **重新应用配置**：

```bash
sudo kubectl apply -f metallb-config.yaml
```

3. **验证配置更新**：

```bash
# 查看 IP 地址池状态
sudo kubectl get ipaddresspools.metallb.io -n metallb-system -o yaml

# 查看 L2Advertisement 状态
sudo kubectl get l2advertisements.metallb.io -n metallb-system -o yaml
```

4. **重启 MetalLB 组件**（如果配置未生效）：

```bash
# 重启 MetalLB 控制器
sudo kubectl rollout restart deployment metallb-controller -n metallb-system

# 重启 MetalLB 扬声器
sudo kubectl rollout restart daemonset metallb-speaker -n metallb-system
```

5. **验证服务状态**：确保所有 MetalLB 组件正常运行

```bash
sudo kubectl get pods -n metallb-system
```

### 3. 验证 MetalLB 部署

```bash
# 查看 MetalLB 组件状态
sudo kubectl get pods -n metallb-system

# 查看 IP 地址池状态
sudo kubectl get ipaddresspools.metallb.io -n metallb-system
```

### 4. 测试 MetalLB

部署一个使用 LoadBalancer 类型的服务：

```bash
sudo kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: test-lb
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
EOF
```

查看服务状态，应该会分配一个来自 MetalLB IP 池的 IP 地址：

```bash
sudo kubectl get services test-lb
```

### 5. 注意事项

- 确保配置的 IP 地址范围在您的网络环境中是可用的，且未被其他设备占用
- MetalLB 会在网络中广播 ARP 包，将分配的 IP 地址映射到节点的 MAC 地址
- 如果使用的是云环境，可能需要额外的网络配置

### 6. 为 LoadBalancer 服务部署固定 IP

在使用 MetalLB 时，可以为 LoadBalancer 类型的服务分配固定 IP 地址，确保服务每次部署都使用相同的 IP。

#### 方法一：通过服务注解指定固定 IP

在创建服务时，通过 ` metallb.universe.tf/loadBalancerIP` 注解指定固定 IP：

```bash
sudo kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-lb
  annotations:
    metallb.universe.tf/loadBalancerIP: 192.168.1.201  # 指定固定 IP
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
EOF
```

#### 方法二：通过 IPAddressPool 配置保留 IP

1. 修改 MetalLB 配置文件，在 IPAddressPool 中添加 `reserved` 字段：

```bash
sudo nano metallb-config.yaml
```

2. 更新配置内容：

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.200-192.168.1.250
  excludedAddresses:
  - 192.168.1.201-192.168.1.205  # 排除的 IP 范围（用于固定 IP）
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default
```

3. 应用配置：

```bash
sudo kubectl apply -f metallb-config.yaml
```

4. 创建服务时指定固定 IP：

```bash
sudo kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-lb

spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
  loadBalancerIP: 192.168.1.201  # 指定固定 IP
EOF
```

#### 验证固定 IP 分配

```bash
# 查看服务状态
sudo kubectl get services nginx-lb

# 验证 IP 地址是否与指定的固定 IP 一致
```

#### 注意事项

- 确保指定的固定 IP 位于 MetalLB 配置的 IP 地址池中
- 如果使用方法二，确保固定 IP 不在 `excludedAddresses` 范围内被其他服务占用
- 固定 IP 分配后，即使服务被删除并重新创建，只要指定相同的 IP，MetalLB 会优先分配该 IP

