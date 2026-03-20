# Redis 使用文档

## 1. 简介

Redis（Remote Dictionary Server）是一个开源的内存数据结构存储系统，它可以用作数据库、缓存和消息中间件。Redis 支持多种数据结构，如字符串、哈希表、列表、集合、有序集合等，并提供了丰富的操作命令。

## 2. 环境搭建

### 2.1 安装 Redis

#### Windows 系统
1. 下载 Redis for Windows：[GitHub 下载](https://github.com/tporadowski/redis/releases)
2. 解压到本地目录，如 `C:\Redis`
3. 运行 `redis-server.exe` 启动服务
4. 运行 `redis-cli.exe` 启动客户端

#### Linux 系统
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install redis-server

# CentOS/RHEL
sudo yum install epel-release
sudo yum install redis
sudo systemctl start redis
sudo systemctl enable redis
```

### 2.2 验证安装

```bash
# 查看 Redis 版本
redis-server --version

# 连接 Redis
redis-cli

# 测试连接
127.0.0.1:6379> PING
PONG
```

## 3. 基本配置

### 3.1 配置文件

Redis 的主要配置文件是 `redis.conf`，通常位于：
- Windows: `C:\Redis\redis.windows.conf`
- Linux: `/etc/redis/redis.conf`

### 3.2 常用配置项

```conf
# 端口
port 6379

# 绑定地址
bind 127.0.0.1

# 密码
requirepass yourpassword

# 内存限制
maxmemory 2gb

# 内存淘汰策略
maxmemory-policy allkeys-lru

# 持久化设置
save 900 1
save 300 10
save 60 10000

# 日志级别
loglevel notice
```

## 4. 基本数据类型

### 4.1 字符串 (String)

```bash
# 设置值
SET key value

# 获取值
GET key

# 自增
INCR key

# 自减
DECR key

# 设置过期时间
SETEX key seconds value

# 获取过期时间
TTL key
```

### 4.2 哈希表 (Hash)

```bash
# 设置字段值
HSET key field value

# 获取字段值
HGET key field

# 获取所有字段和值
HGETALL key

# 获取所有字段
HKEYS key

# 获取所有值
HVALS key

# 字段数量
HLEN key
```

### 4.3 列表 (List)

```bash
# 左侧插入
LPUSH key value1 value2 ...

# 右侧插入
RPUSH key value1 value2 ...

# 左侧弹出
LPOP key

# 右侧弹出
RPOP key

# 获取列表长度
LLEN key

# 获取范围元素
LRANGE key start stop
```

### 4.4 集合 (Set)

```bash
# 添加元素
SADD key member1 member2 ...

# 移除元素
SREM key member1 member2 ...

# 查看所有元素
SMEMBERS key

# 判断元素是否存在
SISMEMBER key member

# 集合大小
SCARD key

# 集合交集
SINTER key1 key2

# 集合并集
SUNION key1 key2

# 集合差集
SDIFF key1 key2
```

### 4.5 有序集合 (Sorted Set)

```bash
# 添加元素
ZADD key score1 member1 score2 member2 ...

# 移除元素
ZREM key member1 member2 ...

# 查看元素分数
ZSCORE key member

# 增加元素分数
ZINCRBY key increment member

# 查看排名（从小到大）
ZRANK key member

# 查看排名（从大到小）
ZREVRANK key member

# 获取范围元素（从小到大）
ZRANGE key start stop

# 获取范围元素（从大到小）
ZREVRANGE key start stop

# 根据分数范围获取元素
ZRANGEBYSCORE key min max
```

## 5. 高级特性

### 5.1 持久化

#### RDB 持久化
```conf
# 900秒内有1个键被修改就持久化
save 900 1
# 300秒内有10个键被修改就持久化
save 300 10
# 60秒内有10000个键被修改就持久化
save 60 10000
```

#### AOF 持久化
```conf
# 开启 AOF 持久化
appendonly yes

# AOF 持久化策略
# appendfsync always  # 每次写入都持久化
appendfsync everysec  # 每秒持久化一次
# appendfsync no      # 由操作系统决定
```

### 5.2 事务

```bash
# 开始事务
MULTI

# 执行命令
SET key1 value1
SET key2 value2

# 提交事务
EXEC

# 取消事务
DISCARD
```

### 5.3 发布/订阅

```bash
# 订阅频道
SUBSCRIBE channel1 channel2

# 发布消息
PUBLISH channel1 message

# 模式订阅
PSUBSCRIBE pattern*  # 订阅所有以 pattern 开头的频道
```

### 5.4 管道

管道允许客户端在一次请求中发送多个命令，减少网络往返时间，提高性能。

```bash
# 使用管道发送多个命令
redis-cli < commands.txt
```

### 5.5 Lua 脚本

Redis 支持使用 Lua 脚本执行原子操作。

```bash
# 执行 Lua 脚本
EVAL "return redis.call('get', KEYS[1])" 1 key
```

## 6. 集群

### 6.1 主从复制

```conf
# 从服务器配置
slaveof masterip masterport

# 主服务器密码
masterauth yourpassword
```

### 6.2 Redis Cluster

Redis Cluster 是 Redis 的分布式解决方案，支持自动分片和高可用。

```bash
# 创建集群
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1

# 连接集群
redis-cli -c -p 7000
```

## 7. 安全最佳实践

1. **设置密码**：使用 `requirepass` 设置强密码
2. **绑定地址**：只绑定必要的 IP 地址
3. **防火墙**：限制 Redis 端口的访问
4. **禁用危险命令**：重命名或禁用危险命令
5. **使用 TLS**：启用 TLS 加密连接
6. **定期备份**：定期备份 Redis 数据
7. **监控**：监控 Redis 性能和安全状态

## 8. 性能优化

### 8.1 内存优化

1. **使用适当的数据类型**：根据业务场景选择合适的数据类型
2. **设置内存限制**：使用 `maxmemory` 设置内存上限
3. **选择合适的淘汰策略**：根据业务需求选择合适的内存淘汰策略
4. **压缩数据**：对于大字符串，考虑使用压缩

### 8.2 命令优化

1. **使用管道**：减少网络往返时间
2. **批量操作**：使用批量命令如 `MSET`、`MGET`
3. **避免大键**：避免存储过大的键值
4. **使用 Lua 脚本**：将多个操作封装为原子操作

### 8.3 配置优化

1. **调整最大连接数**：根据并发需求调整 `maxclients`
2. **优化持久化**：根据业务需求调整持久化策略
3. **调整网络参数**：优化网络相关配置

## 9. 常见问题与解决方案

### 9.1 内存不足

**问题**：Redis 内存使用过高
**解决方案**：
- 设置合理的内存限制
- 选择合适的内存淘汰策略
- 清理无用数据
- 考虑使用集群

### 9.2 连接问题

**问题**：无法连接到 Redis 服务器
**解决方案**：
- 检查 Redis 服务是否运行
- 检查网络连接
- 检查防火墙设置
- 检查密码是否正确

### 9.3 性能问题

**问题**：Redis 响应缓慢
**解决方案**：
- 分析慢查询日志
- 优化命令和数据结构
- 增加内存
- 考虑使用集群

### 9.4 数据丢失

**问题**：Redis 数据意外丢失
**解决方案**：
- 启用持久化
- 定期备份
- 使用主从复制
- 使用 Redis Cluster

## 10. 客户端

### 10.1 命令行客户端

```bash
redis-cli
```

### 10.2 编程语言客户端

- **Java**：Jedis, Lettuce
- **Python**：redis-py
- **Node.js**：ioredis
- **PHP**：phpredis, predis
- **C#**：StackExchange.Redis

### 10.3 GUI 工具

- **Redis Desktop Manager**：跨平台 GUI 工具
- **Another Redis Desktop Manager**：开源 GUI 工具
- **RedisInsight**：Redis 官方 GUI 工具

## 11. 参考资料

- [Redis 官方文档](https://redis.io/documentation)
- [Redis 命令参考](https://redis.io/commands)
- [Redis 设计与实现](https://redisbook.readthedocs.io/en/latest/)
- [Redis 实战](https://book.douban.com/subject/26612779/)
- [Redis 集群教程](https://redis.io/topics/cluster-tutorial)