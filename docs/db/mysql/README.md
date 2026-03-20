# MySQL 使用文档

## 1. 简介

MySQL 是一种关系型数据库管理系统，是最流行的关系型数据库之一。它是一个开源项目，由 Oracle 公司维护和支持。

## 2. 环境搭建

### 2.1 安装 MySQL

#### Windows 系统
1. 下载 MySQL 安装包：[MySQL 官方下载](https://dev.mysql.com/downloads/installer/)
2. 运行安装程序，选择 "Developer Default" 或 "Server Only" 安装类型
3. 按照安装向导完成安装
4. 配置 MySQL 服务，设置 root 密码

#### Linux 系统
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server

# CentOS/RHEL
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
```

### 2.2 验证安装

```bash
mysql --version
# 输出类似: mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

# 登录 MySQL
mysql -u root -p
```

## 3. 基本配置

### 3.1 配置文件

MySQL 的主要配置文件是 `my.cnf` 或 `my.ini`（Windows），通常位于：
- Windows: `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
- Linux: `/etc/my.cnf` 或 `/etc/mysql/my.cnf`

### 3.2 常用配置项

```ini
[mysqld]
# 端口
port = 3306
# 数据目录
datadir = /var/lib/mysql
# 字符集
character-set-server = utf8mb4
# 最大连接数
max_connections = 100
# 缓冲区大小
innodb_buffer_pool_size = 1G
```

## 4. 基本操作

### 4.1 数据库操作

```sql
-- 创建数据库
CREATE DATABASE dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 查看数据库
SHOW DATABASES;

-- 使用数据库
USE dbname;

-- 删除数据库
DROP DATABASE dbname;
```

### 4.2 表操作

```sql
-- 创建表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 查看表结构
DESCRIBE users;

-- 修改表
ALTER TABLE users ADD COLUMN age INT;

-- 删除表
DROP TABLE users;
```

### 4.3 数据操作

```sql
-- 插入数据
INSERT INTO users (name, email) VALUES ('张三', 'zhangsan@example.com');

-- 查询数据
SELECT * FROM users;
SELECT name, email FROM users WHERE age > 18;

-- 更新数据
UPDATE users SET name = '李四' WHERE id = 1;

-- 删除数据
DELETE FROM users WHERE id = 1;
```

## 5. 高级特性

### 5.1 索引

```sql
-- 创建索引
CREATE INDEX idx_email ON users(email);

-- 创建唯一索引
CREATE UNIQUE INDEX idx_email ON users(email);

-- 删除索引
DROP INDEX idx_email ON users;
```

### 5.2 视图

```sql
-- 创建视图
CREATE VIEW user_view AS
SELECT id, name, email FROM users WHERE age > 18;

-- 使用视图
SELECT * FROM user_view;

-- 删除视图
DROP VIEW user_view;
```

### 5.3 存储过程

```sql
-- 创建存储过程
DELIMITER //
CREATE PROCEDURE get_user(IN user_id INT)
BEGIN
    SELECT * FROM users WHERE id = user_id;
END //
DELIMITER ;

-- 调用存储过程
CALL get_user(1);

-- 删除存储过程
DROP PROCEDURE get_user;
```

### 5.4 触发器

```sql
-- 创建触发器
DELIMITER //
CREATE TRIGGER before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END //
DELIMITER ;
```

## 6. 备份与恢复

### 6.1 备份

```bash
# 备份整个数据库
mysqldump -u root -p dbname > dbname_backup.sql

# 备份单个表
mysqldump -u root -p dbname users > users_backup.sql

# 备份多个表
mysqldump -u root -p dbname users orders > backup.sql
```

### 6.2 恢复

```bash
# 恢复数据库
mysql -u root -p dbname < dbname_backup.sql

# 从备份文件恢复表
mysql -u root -p dbname < users_backup.sql
```

## 7. 安全最佳实践

1. **使用强密码**：为所有用户设置复杂密码
2. **最小权限原则**：根据用户需要分配最小必要权限
3. **定期更新**：及时更新 MySQL 版本以修复安全漏洞
4. **限制远程访问**：仅允许必要的 IP 地址访问 MySQL
5. **使用 SSL**：启用 SSL 加密连接
6. **定期备份**：制定定期备份策略
7. **监控异常**：监控数据库访问和性能异常

## 8. 性能优化

### 8.1 查询优化

1. **使用索引**：为常用查询字段创建索引
2. 避免 SELECT *：只选择必要的列
3. **使用 LIMIT**：限制结果集大小
4. **优化 JOIN**：合理使用 JOIN 语句
5. **避免子查询**：尽量使用 JOIN 替代子查询

### 8.2 配置优化

1. **调整缓冲区大小**：根据服务器内存调整 innodb_buffer_pool_size
2. **调整连接数**：根据并发需求调整 max_connections
3. **启用查询缓存**：对于读多写少的场景
4. **调整日志设置**：根据需求调整二进制日志和错误日志

## 9. 常见问题与解决方案

### 9.1 连接问题

**问题**：无法连接到 MySQL 服务器
**解决方案**：
- 检查 MySQL 服务是否运行
- 检查网络连接
- 检查防火墙设置
- 检查用户名和密码

### 9.2 性能问题

**问题**：查询速度慢
**解决方案**：
- 分析查询执行计划
- 添加适当的索引
- 优化查询语句
- 调整 MySQL 配置

### 9.3 数据丢失

**问题**：数据意外丢失
**解决方案**：
- 从备份恢复
- 启用二进制日志进行点恢复
- 实施定期备份策略

## 10. 相关工具

- **MySQL Workbench**：官方图形化管理工具
- **phpMyAdmin**：Web 界面管理工具
- **Navicat**：商业数据库管理工具
- **HeidiSQL**：Windows 平台免费管理工具

## 11. 参考资料

- [MySQL 官方文档](https://dev.mysql.com/doc/)
- [MySQL 教程 - W3Schools](https://www.w3schools.com/mysql/)
- [MySQL 性能调优](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [MySQL 安全指南](https://dev.mysql.com/doc/refman/8.0/en/security.html)