# Apache Doris 安装指南

## 1. 环境准备

### 1.1 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| FE (Frontend) | 8GB 内存，4 核 CPU | 16GB 内存，8 核 CPU |
| BE (Backend) | 16GB 内存，8 核 CPU | 32GB 内存，16 核 CPU |
| 磁盘 | 50GB SSD | 200GB+ SSD |
| 网络 | 千兆网卡 | 万兆网卡 |

### 1.2 软件要求

- **操作系统**：
  - CentOS 7.4+ / RHEL 7.4+
  - Ubuntu 16.04+ / Debian 9+

- **依赖软件**：
  - Java 1.8+ (推荐 OpenJDK 1.8)
  - Python 2.7+ 或 Python 3.6+
  - MySQL 客户端 (用于连接 Doris)

### 1.3 网络要求

- FE 节点之间需要相互通信
- BE 节点需要与 FE 节点通信
- 所有节点需要能够访问 HDFS（如果使用 HDFS 作为存储）

## 2. 安装步骤

### 2.1 下载安装包

从 [Apache Doris 官方网站](https://doris.apache.org/zh-CN/downloads/) 下载最新版本的安装包。

```bash
# 下载安装包
wget https://apache.org/dyn/closer.cgi?path=/doris/x.x.x/apache-doris-x.x.x-bin.tar.gz

# 解压安装包
tar -xzf apache-doris-x.x.x-bin.tar.gz
cd apache-doris-x.x.x-bin
```

### 2.2 配置 FE 节点

#### 2.2.1 编辑 FE 配置文件

```bash
vi fe/conf/fe.conf
```

主要配置项：

```conf
# FE 节点的 IP 地址，建议使用内网 IP
priority_networks = 192.168.1.0/24

# FE 节点的 HTTP 端口
http_port = 8030

# FE 节点的 RPC 端口
rpc_port = 9020

# FE 节点的查询端口
query_port = 9030

# FE 节点的编辑端口
edit_log_port = 9010

# JVM 堆内存设置，建议为物理内存的 50%
JAVA_OPTS = "-Xmx8G -Xms8G -XX:+UseG1GC"

# 元数据存储目录
data_dir = /path/to/doris/fe/data
```

#### 2.2.2 启动 FE 服务

```bash
# 启动 FE 服务
./bin/start_fe.sh --daemon

# 检查 FE 服务状态
ps aux | grep fe
```

### 2.3 配置 BE 节点

#### 2.3.1 编辑 BE 配置文件

```bash
vi be/conf/be.conf
```

主要配置项：

```conf
# BE 节点的 IP 地址，建议使用内网 IP
priority_networks = 192.168.1.0/24

# BE 节点的存储目录，建议使用 SSD
data_dir = /path/to/doris/be/data

# BE 节点的心跳端口
heartbeat_service_port = 9050

# BE 节点的 RPC 端口
thrift_port = 9060

# BE 节点的 HTTP 端口
webserver_port = 8040

# JVM 堆内存设置
JAVA_OPTS = "-Xmx8G -Xms8G"
```

#### 2.3.2 启动 BE 服务

```bash
# 启动 BE 服务
./bin/start_be.sh --daemon

# 检查 BE 服务状态
ps aux | grep be
```

### 2.4 向 FE 注册 BE 节点

使用 MySQL 客户端连接 FE：

```bash
mysql -h fe_host -P 9030 -u root
```

执行注册命令：

```sql
-- 注册 BE 节点
ALTER SYSTEM ADD BACKEND "be_host:9050";

-- 查看 BE 节点状态
SHOW PROC '/backends';
```

### 2.5 配置 Broker 节点（可选）

如果需要从 HDFS 导入数据，需要配置 Broker 节点。

#### 2.5.1 编辑 Broker 配置文件

```bash
vi broker/conf/broker.conf
```

主要配置项：

```conf
# Broker 节点的 HTTP 端口
broker_ipc_port = 8000

# HDFS 配置
hdfs_root_path = hdfs://namenode:9000
fs.defaultFS = hdfs://namenode:9000

# HDFS 用户名
hadoop.username = hdfs
```

#### 2.5.2 启动 Broker 服务

```bash
# 启动 Broker 服务
./bin/start_broker.sh --daemon

# 检查 Broker 服务状态
ps aux | grep broker
```

#### 2.5.3 向 FE 注册 Broker 节点

使用 MySQL 客户端连接 FE：

```bash
mysql -h fe_host -P 9030 -u root
```

执行注册命令：

```sql
-- 注册 Broker 节点
ALTER SYSTEM ADD BROKER broker_name "broker_host:8000";

-- 查看 Broker 节点状态
SHOW PROC '/brokers';
```

## 3. 集群管理

### 3.1 查看集群状态

```sql
-- 查看 FE 节点状态
SHOW PROC '/frontends';

-- 查看 BE 节点状态
SHOW PROC '/backends';

-- 查看 Broker 节点状态
SHOW PROC '/brokers';

-- 查看集群负载
SHOW PROC '/load';
```

### 3.2 添加 FE 节点（高可用）

1. 编辑新 FE 节点的配置文件，设置相同的 `meta_dir`
2. 启动新 FE 节点：

```bash
./bin/start_fe.sh --daemon --helper fe_leader_host:9010
```

3. 查看 FE 节点状态：

```sql
SHOW PROC '/frontends';
```

### 3.3 添加 BE 节点

1. 编辑新 BE 节点的配置文件
2. 启动新 BE 节点：

```bash
./bin/start_be.sh --daemon
```

3. 向 FE 注册新 BE 节点：

```sql
ALTER SYSTEM ADD BACKEND "new_be_host:9050";
```

### 3.4 停止服务

```bash
# 停止 FE 服务
./bin/stop_fe.sh

# 停止 BE 服务
./bin/stop_be.sh

# 停止 Broker 服务
./bin/stop_broker.sh
```

## 4. 常见问题

### 4.1 FE 启动失败

- 检查 `fe/log/fe.out` 日志文件
- 确认端口未被占用
- 检查 `priority_networks` 配置是否正确

### 4.2 BE 启动失败

- 检查 `be/log/be.out` 日志文件
- 确认端口未被占用
- 检查 `priority_networks` 配置是否正确
- 检查 `data_dir` 目录权限

### 4.3 BE 节点注册失败

- 确认 BE 服务已启动
- 确认网络连接正常
- 检查 `priority_networks` 配置是否正确

### 4.4 导入数据失败

- 检查数据文件格式是否正确
- 确认 Broker 服务已启动（如果从 HDFS 导入）
- 检查网络连接正常

## 5. 性能优化

### 5.1 FE 优化

- 增加 JVM 堆内存：`JAVA_OPTS = "-Xmx16G -Xms16G"`
- 调整元数据缓存大小：`metadata_fetcher_thread_pool_size = 10`

### 5.2 BE 优化

- 增加 JVM 堆内存：`JAVA_OPTS = "-Xmx16G -Xms16G"`
- 调整线程池大小：`be_thread_pool_size = 100`
- 使用 SSD 存储

### 5.3 查询优化

- 创建适当的物化视图
- 合理设置分区和分桶
- 使用索引加速查询
- 避免全表扫描

## 6. 监控与告警

### 6.1 内置监控

Doris 提供了内置的 Web 界面：

- FE 监控：`http://fe_host:8030`
- BE 监控：`http://be_host:8040`

### 6.2 集成 Prometheus

Doris 支持通过 Prometheus 监控：

1. 配置 Prometheus 采集 Doris 指标
2. 使用 Grafana 展示监控面板

## 7. 备份与恢复

### 7.1 数据备份

```sql
-- 创建备份
BACKUP SNAPSHOT example_db.snapshot_name
TO "hdfs://namenode:9000/path/to/backup"
WITH BROKER "broker_name"
PROPERTIES(
    "timeout" = "3600"
);

-- 查看备份状态
SHOW BACKUP;
```

### 7.2 数据恢复

```sql
-- 恢复数据
RESTORE SNAPSHOT example_db.snapshot_name
FROM "hdfs://namenode:9000/path/to/backup"
WITH BROKER "broker_name"
PROPERTIES(
    "timeout" = "3600"
);

-- 查看恢复状态
SHOW RESTORE;
```

## 8. 版本升级

### 8.1 升级 FE 节点

1. 停止 FE 服务
2. 替换 FE 安装包
3. 启动 FE 服务

### 8.2 升级 BE 节点

1. 停止 BE 服务
2. 替换 BE 安装包
3. 启动 BE 服务
4. 等待 BE 节点重新注册到 FE

### 8.3 升级 Broker 节点

1. 停止 Broker 服务
2. 替换 Broker 安装包
3. 启动 Broker 服务
4. 等待 Broker 节点重新注册到 FE

## 9. 参考资料

- [Apache Doris 官方文档](https://doris.apache.org/zh-CN/docs/) 
- [Apache Doris GitHub 仓库](https://github.com/apache/doris)
- [Apache Doris 社区](https://doris.apache.org/zh-CN/community/)
