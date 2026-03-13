# K3s 部署示例

本文档提供了在 K3s 集群中部署应用的示例配置。

## 目录结构

```
examples/
├── nginx-deployment.yaml  # Nginx 部署配置
├── nginx-service.yaml     # Nginx 服务配置
└── README.md              # 部署说明
```

## 部署 Nginx 示例

### 步骤 1：部署 Nginx Deployment

执行以下命令部署 Nginx：

```bash
kubectl apply -f nginx-deployment.yaml
```

### 步骤 2：部署 Nginx Service

执行以下命令创建 Service：

```bash
kubectl apply -f nginx-service.yaml
```

### 步骤 3：验证部署

```bash
# 查看 Deployment 状态
kubectl get deployments

# 查看 Pod 状态
kubectl get pods

# 查看 Service 状态
kubectl get services
```

### 步骤 4：访问 Nginx 服务

由于 Service 类型为 ClusterIP，只能在集群内部访问：

```bash
# 在集群内的 Pod 中访问
kubectl run -it --rm --image=busybox:latest busybox -- wget -O - http://nginx-service

# 或者使用 port-forward 访问
kubectl port-forward service/nginx-service 8080:80
# 然后在浏览器中访问 http://localhost:8080
```

## 自定义配置

### 修改副本数

编辑 `nginx-deployment.yaml` 文件，修改 `replicas` 字段：

```yaml
spec:
  replicas: 3  # 修改为所需的副本数
```

### 扩容与缩容 (Scaling)

使用 `kubectl scale` 命令可以动态调整副本数，无需停机：

```bash
# 扩容到 3 个副本
kubectl scale deployment nginx-deployment --replicas=3

# 缩容到 1 个副本
kubectl scale deployment nginx-deployment --replicas=1
```

### 验证扩容过程

扩容过程中，Kubernetes 会使用滚动更新策略，确保服务不中断：

```bash
# 查看 Deployment 状态，观察滚动更新进度
kubectl rollout status deployment nginx-deployment

# 查看 Pod 状态，确认新 Pod 启动和旧 Pod 终止情况
kubectl get pods -w
```

这样，即使在扩容或缩容过程中，服务也能保持可用，实现不停服部署。

### 修改镜像版本

编辑 `nginx-deployment.yaml` 文件，修改 `image` 字段：

```yaml
containers:
- name: nginx
  image: nginx:1.23.0  # 修改为所需的镜像版本
```

### 修改资源限制

编辑 `nginx-deployment.yaml` 文件，修改 `resources` 字段：

```yaml
resources:
  limits:
    cpu: "1"
    memory: "1Gi"
  requests:
    cpu: "500m"
    memory: "512Mi"
```

### 修改 Service 类型

编辑 `nginx-service.yaml` 文件，修改 `type` 字段：

```yaml
type: NodePort  # 改为 NodePort 类型，可从集群外部访问
```

## 清理部署

执行以下命令删除部署：

```bash
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-deployment.yaml
```

## 其他示例

### 部署 MySQL

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password"
        - name: MYSQL_DATABASE
          value: "example"
        resources:
          limits:
            cpu: "1"
            memory: "1Gi"
          requests:
            cpu: "500m"
            memory: "512Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: default
spec:
  selector:
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306
  type: ClusterIP
```

### 部署 WordPress

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-deployment
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:5.8
        ports:
        - containerPort: 80
        env:
        - name: WORDPRESS_DB_HOST
          value: "mysql-service"
        - name: WORDPRESS_DB_NAME
          value: "example"
        - name: WORDPRESS_DB_USER
          value: "root"
        - name: WORDPRESS_DB_PASSWORD
          value: "password"
        resources:
          limits:
            cpu: "1"
            memory: "1Gi"
          requests:
            cpu: "500m"
            memory: "512Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: wordpress-service
  namespace: default
spec:
  selector:
    app: wordpress
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```

## 参考资源

- [Kubernetes 部署文档](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes Service 文档](https://kubernetes.io/docs/concepts/services-networking/service/)
- [K3s 官方文档](https://docs.k3s.io/)
