# MySQL 安装文档

## 1. 安装前准备

### 1.1 系统要求

| 操作系统 | 最低配置 | 推荐配置 |
|---------|---------|----------|
| Windows | CPU: 1GHz 以上<br>内存: 2GB 以上<br>磁盘空间: 200MB 以上 | CPU: 2GHz 以上<br>内存: 4GB 以上<br>磁盘空间: 500MB 以上 |
| Linux | CPU: 1GHz 以上<br>内存: 2GB 以上<br>磁盘空间: 200MB 以上 | CPU: 2GHz 以上<br>内存: 4GB 以上<br>磁盘空间: 500MB 以上 |
| macOS | CPU: 1GHz 以上<br>内存: 2GB 以上<br>磁盘空间: 200MB 以上 | CPU: 2GHz 以上<br>内存: 4GB 以上<br>磁盘空间: 500MB 以上 |

### 1.2 网络要求

- 确保网络连接正常，以便下载安装包
- 如需远程访问 MySQL，确保防火墙已开放 3306 端口

### 1.3 版本选择

MySQL 提供多个版本，根据需求选择：

- **MySQL Community Server**: 免费开源版本，适合大多数应用场景
- **MySQL Enterprise Edition**: 商业版本，提供更多企业级功能
- **MySQL Cluster**: 高可用性集群版本

## 2. Windows 系统安装

### 2.1 通过安装程序安装

1. **下载安装包**
   - 访问 [MySQL 官方下载页面](https://dev.mysql.com/downloads/installer/)
   - 选择适合的版本（推荐使用最新的稳定版）
   - 下载 "MySQL Installer for Windows"

2. **运行安装程序**
   - 双击下载的安装包
   - 选择安装类型：
     - **Developer Default**: 适合开发人员，包含 MySQL 服务器、Workbench 等工具
     - **Server Only**: 仅安装 MySQL 服务器
     - **Client Only**: 仅安装客户端工具
     - **Full**: 安装所有组件
     - **Custom**: 自定义安装组件

3. **配置 MySQL 服务器**
   - 选择配置类型：
     - **Development Computer**: 适合开发环境
     - **Server Computer**: 适合服务器环境
     - **Dedicated Computer**: 适合专用数据库服务器
   - 设置 TCP/IP 端口（默认 3306）
   - 启用或禁用 Strict Mode

4. **设置 root 密码**
   - 为 root 用户设置强密码
   - 可选择添加其他用户并设置权限

5. **配置 Windows 服务**
   - 设置服务名称（默认 MySQL80）
   - 选择启动类型（建议设置为自动）

6. **完成安装**
   - 点击 "Execute" 执行配置
   - 等待安装完成

### 2.2 通过 ZIP 包安装

1. **下载 ZIP 包**
   - 访问 [MySQL 官方下载页面](https://dev.mysql.com/downloads/mysql/)
   - 选择 "Windows (x86, 64-bit), ZIP Archive"
   - 下载并解压到目标目录（例如 `C:\mysql`）

2. **创建配置文件**
   - 在解压目录中创建 `my.ini` 文件
   - 配置内容示例：

```ini
[mysqld]
basedir=C:\mysql
datadir=C:\mysql\data
port=3306
character-set-server=utf8mb4
default-storage-engine=INNODB

[mysql]
default-character-set=utf8mb4
```

3. **初始化数据库**
   - 打开命令提示符（以管理员身份运行）
   - 进入 MySQL 解压目录的 bin 文件夹
   - 执行初始化命令：

```bash
mysqld --initialize-insecure
```

4. **安装 Windows 服务**

```bash
mysqld --install MySQL80 --defaults-file="C:\mysql\my.ini"
```

5. **启动服务**

```bash
net start MySQL80
```

6. **设置 root 密码**

```bash
mysqladmin -u root password "your_password"
```

## 3. Linux 系统安装

### 3.1 Ubuntu/Debian 系统

1. **更新系统**

```bash
sudo apt update
sudo apt upgrade
```

2. **安装 MySQL**

```bash
sudo apt install mysql-server
```

3. **初始化配置**

```bash
sudo mysql_secure_installation
```

   - 按照提示设置 root 密码
   - 选择是否移除匿名用户
   - 选择是否禁止 root 远程登录
   - 选择是否移除 test 数据库
   - 选择是否重新加载权限表

4. **启动并启用服务**

```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 3.2 CentOS/RHEL 系统

1. **安装 MySQL 仓库**

```bash
# CentOS 8/RHEL 8
sudo dnf install https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm

# CentOS 7/RHEL 7
sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
```

2. **安装 MySQL**

```bash
# CentOS 8/RHEL 8
sudo dnf install mysql-server

# CentOS 7/RHEL 7
sudo yum install mysql-server
```

3. **启动并启用服务**

```bash
sudo systemctl start mysqld
sudo systemctl enable mysqld
```

4. **查看临时密码**

```bash
sudo grep 'temporary password' /var/log/mysqld.log
```

5. **初始化配置**

```bash
sudo mysql_secure_installation
```

   - 输入临时密码
   - 设置新的 root 密码
   - 按照提示完成其他配置

### 3.3 其他 Linux 发行版

请参考 [MySQL 官方文档](https://dev.mysql.com/doc/refman/8.0/en/linux-installation.html) 进行安装。

## 4. macOS 系统安装

### 4.1 通过 DMG 包安装

1. **下载 DMG 包**
   - 访问 [MySQL 官方下载页面](https://dev.mysql.com/downloads/mysql/)
   - 选择 "macOS (x86, 64-bit), DMG Archive"
   - 下载并打开 DMG 文件

2. **运行安装程序**
   - 双击 `.pkg` 文件
   - 按照安装向导完成安装

3. **配置 MySQL**
   - 安装完成后，系统偏好设置中会出现 MySQL 图标
   - 点击图标进入 MySQL 配置界面
   - 启动 MySQL 服务
   - 点击 "Initialize Database" 设置 root 密码

### 4.2 通过 Homebrew 安装

1. **安装 Homebrew**（如果尚未安装）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. **安装 MySQL**

```bash
brew install mysql
```

3. **启动 MySQL**

```bash
brew services start mysql
```

4. **初始化配置**

```bash
mysql_secure_installation
```

## 5. 安装验证

### 5.1 验证 MySQL 服务状态

**Windows**:

```bash
net start | findstr MySQL
```

**Linux**:

```bash
sudo systemctl status mysql
```

**macOS**:

```bash
brew services list | grep mysql
```

### 5.2 验证 MySQL 版本

```bash
mysql --version
```

### 5.3 登录 MySQL

```bash
mysql -u root -p
```

输入密码后，应看到 MySQL 命令行提示符：

```
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

## 6. 安装后配置

### 6.1 配置文件调整

根据系统类型，找到并编辑配置文件：

- **Windows**: `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
- **Linux**: `/etc/my.cnf` 或 `/etc/mysql/my.cnf`
- **macOS**: `/usr/local/mysql/my.cnf` 或 `~/.my.cnf`

### 6.2 常用配置项

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
# 日志设置
log-error = /var/log/mysql/error.log
pid-file = /var/run/mysqld/mysqld.pid
```

### 6.3 重启服务使配置生效

**Windows**:

```bash
net stop MySQL80
net start MySQL80
```

**Linux**:

```bash
sudo systemctl restart mysql
```

**macOS**:

```bash
brew services restart mysql
```

## 7. 常见安装问题与解决方案

### 7.1 端口被占用

**问题**：安装过程中提示 3306 端口被占用

**解决方案**：
1. 检查哪个进程占用了 3306 端口
   - Windows: `netstat -ano | findstr :3306`
   - Linux/macOS: `lsof -i :3306`
2. 停止占用端口的进程或修改 MySQL 端口

### 7.2 权限问题

**问题**：安装后无法登录 MySQL

**解决方案**：
1. 检查用户名和密码是否正确
2. 检查 MySQL 服务是否运行
3. 尝试重置 root 密码

### 7.3 服务启动失败

**问题**：MySQL 服务无法启动

**解决方案**：
1. 查看错误日志
   - Windows: `C:\ProgramData\MySQL\MySQL Server 8.0\Data\{hostname}.err`
   - Linux: `/var/log/mysql/error.log`
   - macOS: `/usr/local/mysql/data/{hostname}.err`
2. 根据错误信息进行排查

### 7.4 依赖问题

**问题**：安装过程中提示缺少依赖

**解决方案**：
- Windows: 安装程序会自动处理依赖
- Linux: 使用包管理器安装缺少的依赖
  - Ubuntu/Debian: `sudo apt install -f`
  - CentOS/RHEL: `sudo yum install -y {dependency}`
- macOS: 使用 Homebrew 安装缺少的依赖

## 8. 版本兼容性

| MySQL 版本 | 支持的操作系统 | 最低 Java 版本 | 最低 PHP 版本 |
|-----------|----------------|---------------|---------------|
| 8.0.x     | Windows 7+<br>Linux (各种发行版)<br>macOS 10.14+ | Java 8+ | PHP 7.2+ |
| 5.7.x     | Windows 7+<br>Linux (各种发行版)<br>macOS 10.12+ | Java 7+ | PHP 5.6+ |

## 9. 卸载 MySQL

### 9.1 Windows 系统

1. **通过控制面板卸载**
   - 打开 "控制面板" → "程序和功能"
   - 找到 MySQL 相关程序并卸载

2. **删除残留文件**
   - 删除 `C:\Program Files\MySQL` 目录
   - 删除 `C:\ProgramData\MySQL` 目录
   - 删除 `C:\Users\{username}\AppData\Roaming\MySQL` 目录

3. **删除服务**
   - 以管理员身份运行命令提示符
   - 执行 `sc delete MySQL80`（根据实际服务名称调整）

### 9.2 Linux 系统

**Ubuntu/Debian**:

```bash
sudo apt purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt autoremove
sudo apt autoclean
```

**CentOS/RHEL**:

```bash
sudo systemctl stop mysqld
sudo yum remove mysql-server mysql-client
sudo rm -rf /var/lib/mysql /etc/my.cnf
sudo yum autoremove
```

### 9.3 macOS 系统

**通过 DMG 安装的**:
- 打开 "系统偏好设置" → "MySQL"
- 点击 "Uninstall"

**通过 Homebrew 安装的**:

```bash
brew services stop mysql
brew uninstall mysql
rm -rf /usr/local/var/mysql
```

## 10. 参考资料

- [MySQL 官方安装文档](https://dev.mysql.com/doc/refman/8.0/en/installing.html)
- [MySQL Windows 安装指南](https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html)
- [MySQL Linux 安装指南](https://dev.mysql.com/doc/refman/8.0/en/linux-installation.html)
- [MySQL macOS 安装指南](https://dev.mysql.com/doc/refman/8.0/en/macos-installation.html)
