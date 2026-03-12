# Kubectl 常用命令文档

本文档汇总了 K3s 环境中 kubectl 的常用命令，帮助开发者快速上手 Kubernetes 集群管理。

## 基本命令

### 集群信息

```bash
# 查看集群信息
kubectl cluster-info

# 查看节点信息
kubectl get nodes

# 查看节点详细信息
kubectl describe nodes

# 查看集群组件状态
kubectl get componentstatuses
```

### 命名空间管理

```bash
# 查看所有命名空间
kubectl get namespaces

# 创建命名空间
kubectl create namespace <namespace-name>

# 删除命名空间
kubectl delete namespace <namespace-name>

# 切换命名空间（需要安装 kubens 工具）
kubens <namespace-name>
```

## 资源管理

### Pod 操作

```bash
# 查看所有 Pod
kubectl get pods --all-namespaces

# 查看指定命名空间的 Pod
kubectl get pods -n <namespace>

# 查看 Pod 详细信息
kubectl describe pod <pod-name> -n <namespace>

# 查看 Pod 日志
kubectl logs <pod-name> -n <namespace>

# 实时查看 Pod 日志
kubectl logs -f <pod-name> -n <namespace>

# 进入 Pod 容器
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash

# 删除 Pod
kubectl delete pod <pod-name> -n <namespace>
```

### Deployment 操作

```bash
# 查看所有 Deployment
kubectl get deployments --all-namespaces

# 查看指定命名空间的 Deployment
kubectl get deployments -n <namespace>

# 查看 Deployment 详细信息
kubectl describe deployment <deployment-name> -n <namespace>

# 缩放 Deployment
kubectl scale deployment <deployment-name> --replicas=<number> -n <namespace>

# 更新 Deployment 镜像
kubectl set image deployment <deployment-name> <container-name>=<image>:<tag> -n <namespace>

# 删除 Deployment
kubectl delete deployment <deployment-name> -n <namespace>
```

### Service 操作

```bash
# 查看所有 Service
kubectl get services --all-namespaces

# 查看指定命名空间的 Service
kubectl get services -n <namespace>

# 查看 Service 详细信息
kubectl describe service <service-name> -n <namespace>

# 删除 Service
kubectl delete service <service-name> -n <namespace>
```

### ConfigMap 操作

```bash
# 查看所有 ConfigMap
kubectl get configmaps --all-namespaces

# 查看指定命名空间的 ConfigMap
kubectl get configmaps -n <namespace>

# 查看 ConfigMap 详细信息
kubectl describe configmap <configmap-name> -n <namespace>

# 创建 ConfigMap
kubectl create configmap <configmap-name> --from-file=<file-path> -n <namespace>

# 删除 ConfigMap
kubectl delete configmap <configmap-name> -n <namespace>
```

### Secret 操作

```bash
# 查看所有 Secret
kubectl get secrets --all-namespaces

# 查看指定命名空间的 Secret
kubectl get secrets -n <namespace>

# 查看 Secret 详细信息
kubectl describe secret <secret-name> -n <namespace>

# 创建 Secret
kubectl create secret generic <secret-name> --from-literal=<key>=<value> -n <namespace>

# 删除 Secret
kubectl delete secret <secret-name> -n <namespace>
```

## 高级操作

### 资源监控

```bash
# 查看节点资源使用情况
kubectl top nodes

# 查看 Pod 资源使用情况
kubectl top pods -n <namespace>
```

### 滚动更新

```bash
# 查看滚动更新状态
kubectl rollout status deployment <deployment-name> -n <namespace>

# 回滚 Deployment
kubectl rollout undo deployment <deployment-name> -n <namespace>

# 查看 Deployment 历史
kubectl rollout history deployment <deployment-name> -n <namespace>

# 回滚到指定版本
kubectl rollout undo deployment <deployment-name> --to-revision=<revision> -n <namespace>
```

### 标签和注解

```bash
# 为 Pod 添加标签
kubectl label pod <pod-name> <label-key>=<label-value> -n <namespace>

# 为 Pod 添加注解
kubectl annotate pod <pod-name> <annotation-key>=<annotation-value> -n <namespace>

# 查看带有特定标签的 Pod
kubectl get pods -l <label-key>=<label-value> -n <namespace>
```

### 网络策略

```bash
# 查看网络策略
kubectl get networkpolicies --all-namespaces

# 查看网络策略详细信息
kubectl describe networkpolicy <networkpolicy-name> -n <namespace>
```

## K3s 特有命令

### K3s 服务管理

```bash
# 启动 K3s 服务
systemctl start k3s

# 停止 K3s 服务
systemctl stop k3s

# 重启 K3s 服务
systemctl restart k3s

# 查看 K3s 服务状态
systemctl status k3s

# 查看 K3s 日志
journalctl -u k3s -f
```

### K3s 配置管理

```bash
# 查看 K3s 配置文件
cat /etc/rancher/k3s/config.yaml

# 查看 K3s 版本
k3s --version

# 查看 K3s 节点令牌
cat /var/lib/rancher/k3s/server/node-token
```

### K3s 备份与恢复

```bash
# 备份 etcd 数据
k3s etcd-snapshot save --name <snapshot-name>

# 查看备份列表
k3s etcd-snapshot list

# 恢复 etcd 数据
k3s server --cluster-reset --cluster-reset-restore-path=/path/to/snapshot
```

## 常用别名

为了提高操作效率，可以在 `~/.bashrc` 或 `~/.zshrc` 中添加以下别名：

```bash
# kubectl 别名
alias k=kubectl

# 常用命令别名
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgn="kubectl get namespaces"
alias kd="kubectl describe"
alias kl="kubectl logs"
alias ke="kubectl exec -it"
```

## 命令格式技巧

### 使用 -o 选项格式化输出

```bash
# 输出为 JSON 格式
kubectl get pods -n <namespace> -o json

# 输出为 YAML 格式
kubectl get pods -n <namespace> -o yaml

# 输出为自定义列
kubectl get pods -n <namespace> -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# 输出为宽格式（显示更多信息）
kubectl get pods -n <namespace> -o wide
```

### 使用 --sort-by 排序

```bash
# 按名称排序
kubectl get pods -n <namespace> --sort-by=.metadata.name

# 按创建时间排序
kubectl get pods -n <namespace> --sort-by=.metadata.creationTimestamp

# 按状态排序
kubectl get pods -n <namespace> --sort-by=.status.phase
```

### 使用 --field-selector 过滤

```bash
# 过滤运行中的 Pod
kubectl get pods -n <namespace> --field-selector status.phase=Running

# 过滤特定节点上的 Pod
kubectl get pods -n <namespace> --field-selector spec.nodeName=<node-name>
```

## 故障排查

### 常见问题排查

```bash
# 查看 Pod 事件
kubectl get events -n <namespace>

# 查看 Pod 详细信息（包括事件）
kubectl describe pod <pod-name> -n <namespace>

# 检查集群健康状态
kubectl get componentstatuses

# 检查 API 服务器状态
curl -k https://localhost:6443/healthz
```

### 资源问题排查

```bash
# 查看节点资源使用情况
kubectl top nodes

# 查看 Pod 资源使用情况
kubectl top pods -n <namespace>

# 查看资源限制和请求
kubectl get pods -n <namespace> -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{range .spec.containers[*]}{"  "}{.name}{"\n"}{"    资源限制: "}{.resources.limits}{"\n"}{"    资源请求: "}{.resources.requests}{"\n"}{end}{end}'
```

## 参考资源

- [kubectl 官方文档](https://kubernetes.io/docs/reference/kubectl/)
- [K3s 官方文档](https://docs.k3s.io/)
- [Kubernetes 命令行工具指南](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
