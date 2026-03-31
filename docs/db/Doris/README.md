# Apache Doris 使用说明

## 1. 简介

Apache Doris 是一个基于 MPP 架构的高性能、实时分析型数据库，主要用于大规模数据的实时分析场景。它具有以下特点：

- **高性能**：支持高并发低延迟查询
- **高可靠性**：支持数据副本和自动故障恢复
- **易扩展**：支持水平扩展，适应不同规模的数据量
- **兼容性好**：兼容 MySQL 协议，易于集成现有系统

## 2. 安装部署

### 2.1 环境要求

- **操作系统**：Linux（推荐 CentOS 7.4+ 或 Ubuntu 16.04+）
- **Java**：JDK 1.8+
- **内存**：Master 节点建议 8GB+，BE 节点建议 16GB+
- **磁盘**：建议使用 SSD 存储
- **网络**：千兆网络以上

### 2.2 安装步骤

#### 2.2.1 下载安装包

从 [Apache Doris 官方网站](https://doris.apache.org/zh-CN/downloads/) 下载最新版本的安装包。

#### 2.2.2 解压安装包

```bash
tar -xzf apache-doris-x.x.x-bin.tar.gz
cd apache-doris-x.x.x-bin
```

#### 2.2.3 配置环境变量

编辑 `~/.bashrc` 文件，添加以下内容：

```bash
export DORIS_HOME=/path/to/apache-doris-x.x.x-bin
export PATH=$DORIS_HOME/bin:$PATH
```

然后执行 `source ~/.bashrc` 使环境变量生效。

#### 2.2.4 配置 FE（Frontend）

编辑 `fe/conf/fe.conf` 文件，主要配置项如下：

```conf
# FE 节点的 IP 地址
priority_networks = 192.168.1.0/24

# FE 节点的 HTTP 端口
http_port = 8030

# FE 节点的 RPC 端口
rpc_port = 9020

# FE 节点的查询端口
query_port = 9030

# JVM 堆内存设置
JAVA_OPTS = "-Xmx8G -Xms8G"
```

#### 2.2.5 配置 BE（Backend）

编辑 `be/conf/be.conf` 文件，主要配置项如下：

```conf
# BE 节点的 IP 地址
priority_networks = 192.168.1.0/24

# BE 节点的存储目录
data_dir = /path/to/doris/data

# JVM 堆内存设置
JAVA_OPTS = "-Xmx8G -Xms8G"
```

#### 2.2.6 启动服务

1. 启动 FE 服务：

```bash
./bin/start_fe.sh --daemon
```

2. 启动 BE 服务：

```bash
./bin/start_be.sh --daemon
```

3. 向 FE 注册 BE 节点：

使用 MySQL 客户端连接 FE：

```bash
mysql -h 127.0.0.1 -P 9030 -u root
```

执行注册命令：

```sql
ALTER SYSTEM ADD BACKEND "be_host:9050";
```

## 3. 基本操作

### 3.1 连接数据库

使用 MySQL 客户端连接 Doris：

```bash
mysql -h fe_host -P 9030 -u root
```

### 3.2 创建数据库

```sql
CREATE DATABASE example_db;
USE example_db;
```

### 3.3 创建表

#### 3.3.1 建表语句

```sql
CREATE TABLE IF NOT EXISTS `user_log` (
  `user_id` LARGEINT NOT NULL COMMENT "用户ID",
  `item_id` LARGEINT NOT NULL COMMENT "商品ID",
  `behavior` VARCHAR(32) NOT NULL COMMENT "用户行为",
  `ts` DATETIME NOT NULL COMMENT "时间戳"
) ENGINE=OLAP
DUPLICATE KEY(`user_id`, `item_id`, `ts`)
PARTITION BY RANGE(ts)() DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES(
  "dynamic_partition.enable" = "true",
  "dynamic_partition.time_unit" = "DAY",
  "dynamic_partition.start" = "-90",
  "dynamic_partition.end" = "7",
  "dynamic_partition.prefix" = "p",
  "dynamic_partition.history_partition_num" = "0",
  "replication_num" = "3"
);
```

### 3.4 数据导入

#### 3.4.1 从本地文件导入

```sql
LOAD LABEL example_db.label1
(LOAD DATA INFILE "file:///path/to/data.csv" INTO TABLE user_log
COLUMNS TERMINATED BY ","
(user_id, item_id, behavior, ts)
)
WITH BROKER "broker_name"
PROPERTIES(
    "timeout" = "3600"
);
```

#### 3.4.2 从 HDFS 导入

```sql
LOAD LABEL example_db.label2
(LOAD DATA INFILE "hdfs://namenode:9000/path/to/data.csv" INTO TABLE user_log
COLUMNS TERMINATED BY ","
(user_id, item_id, behavior, ts)
)
WITH BROKER "broker_name"
PROPERTIES(
    "timeout" = "3600"
);
```

### 3.5 查询数据

```sql
SELECT behavior, COUNT(*) as cnt FROM user_log GROUP BY behavior ORDER BY cnt DESC;
```

## 4. 高级特性

### 4.1 物化视图

物化视图可以加速查询性能：

```sql
CREATE MATERIALIZED VIEW mv_user_behavior
AS SELECT behavior, COUNT(*) as cnt FROM user_log GROUP BY behavior;
```

### 4.2 分区管理

#### 4.2.1 查看分区

```sql
SHOW PARTITIONS FROM user_log;
```

#### 4.2.2 手动添加分区

```sql
ALTER TABLE user_log ADD PARTITION p20230101 VALUES [('2023-01-01 00:00:00'), ('2023-01-02 00:00:00'));
```

#### 4.2.3 删除分区

```sql
ALTER TABLE user_log DROP PARTITION p20230101;
```

### 4.3 数据备份与恢复

#### 4.3.1 创建备份

```sql
BACKUP SNAPSHOT example_db.snapshot_name
TO "hdfs://namenode:9000/path/to/backup"
WITH BROKER "broker_name"
PROPERTIES(
    "timeout" = "3600"
);
```

#### 4.3.2 恢复数据

```sql
RESTORE SNAPSHOT example_db.snapshot_name
FROM "hdfs://namenode:9000/path/to/backup"
WITH BROKER "broker_name"
PROPERTIES(
    "timeout" = "3600"
);
```

## 5. 监控与维护

### 5.1 查看集群状态

```sql
SHOW PROC '/frontends';
SHOW PROC '/backends';
```

### 5.2 查看查询状态

```sql
SHOW PROC '/queries';
```

### 5.3 查看系统负载

```sql
SHOW PROC '/load';
```

### 5.4 常见问题排查

- **FE 启动失败**：检查 `fe/log` 目录下的日志文件
- **BE 启动失败**：检查 `be/log` 目录下的日志文件
- **查询缓慢**：使用 `EXPLAIN` 分析查询计划，检查是否需要创建索引或物化视图

## 6. 最佳实践

### 6.1 表设计

- **选择合适的分桶列**：通常选择高基数的列作为分桶列
- **合理设置分区**：根据数据量和查询模式设置分区策略
- **使用适当的数据类型**：根据实际数据大小选择合适的数据类型

### 6.2 导入优化

- **批量导入**：尽量使用批量导入，减少导入次数
- **合理设置并行度**：根据集群资源设置适当的导入并行度
- **使用 Broker 导入**：对于大文件，使用 Broker 导入可以提高性能

### 6.3 查询优化

- **使用物化视图**：对于频繁查询的聚合结果，使用物化视图
- **合理使用索引**：在过滤条件列上创建索引
- **避免全表扫描**：尽量使用分区裁剪和谓词下推

## 7. 参考资料

- [Apache Doris 官方文档](https://doris.apache.org/zh-CN/docs/) 
- [Apache Doris GitHub 仓库](https://github.com/apache/doris)
- [Apache Doris 社区](https://doris.apache.org/zh-CN/community/)
