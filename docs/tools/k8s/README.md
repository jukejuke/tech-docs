# Kubernetes 资源配置说明

本文档提供了 Kubernetes 中 Deployment 和 Service 资源的配置示例和说明。

## 目录结构

```
./k8s/
├── deployment.yaml    # Deployment 资源配置
├── service.yaml       # Service 资源配置
└── README.md          # 本文档
```

## Deployment 配置

### 功能说明

Deployment 用于管理 Pod 的副本数、更新策略和滚动更新等功能，确保应用的高可用性和稳定性。

### 配置示例

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
  namespace: default
  labels:
    app: example-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: example-app
    spec:
      containers:
      - name: example-app
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "200m"
            memory: "256Mi"
```

### 关键参数说明

- `replicas`: 指定 Pod 的副本数
- `selector`: 用于选择要管理的 Pod
- `strategy`: 定义更新策略，默认为 RollingUpdate
- `template`: 定义 Pod 的模板
- `resources`: 配置容器的资源限制

## Service 配置

### 功能说明

Service 用于暴露应用，提供稳定的访问地址，支持不同的访问方式（ClusterIP、NodePort、LoadBalancer 等）。

### 配置示例

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-app
  namespace: default
spec:
  selector:
    app: example-app
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
  type: ClusterIP
```

### 关键参数说明

- `selector`: 用于选择要暴露的 Pod
- `ports`: 定义端口映射
  - `port`: Service 暴露的端口
  - `targetPort`: Pod 中容器的端口
- `type`: Service 的类型，可选值：
  - `ClusterIP`: 仅在集群内部可访问
  - `NodePort`: 在每个节点上暴露端口
  - `LoadBalancer`: 外部负载均衡器
  - `ExternalName`: 映射到外部服务

## 部署步骤

1. 应用 Deployment 配置：
   ```bash
   kubectl apply -f deployment.yaml
   ```

2. 应用 Service 配置：
   ```bash
   kubectl apply -f service.yaml
   ```

3. 验证部署：
   ```bash
   kubectl get deployments
   kubectl get services
   kubectl get pods
   ```

## 常见问题

### Pod 无法启动

- 检查镜像是否存在
- 检查资源是否足够
- 查看 Pod 日志：`kubectl logs <pod-name>`

### Service 无法访问

- 检查 Service 与 Pod 的标签是否匹配
- 检查网络策略是否允许访问
- 验证端口映射是否正确

## 最佳实践

1. 使用标签和注解来组织资源
2. 合理设置资源请求和限制
3. 使用健康检查（livenessProbe 和 readinessProbe）
4. 配置适当的更新策略
5. 定期备份配置文件
