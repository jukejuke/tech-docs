# Git 使用指南

Git 是一个分布式版本控制系统，用于跟踪项目中文件的变化。

## 安装

### Windows

1. 下载 Git for Windows 安装包：[https://git-scm.com/download/win](https://git-scm.com/download/win)
2. 运行安装程序，按照默认选项进行安装
3. 安装完成后，打开 Git Bash 验证安装

### macOS

1. 使用 Homebrew 安装：`brew install git`
2. 或从官网下载安装包：[https://git-scm.com/download/mac](https://git-scm.com/download/mac)

### Linux

1. Ubuntu/Debian：`sudo apt install git`
2. CentOS/RHEL：`sudo yum install git`

## 基本使用

### 初始化仓库

```bash
git init
```

### 克隆仓库

```bash
git clone <repository-url>
```

### 添加文件

```bash
git add <file>
# 或添加所有文件
git add .
```

### 提交更改

```bash
git commit -m "提交信息"
```

### 推送更改

```bash
git push origin <branch>
```

### 拉取更改

```bash
git pull origin <branch>
```

## 分支管理

### 创建分支

```bash
git checkout -b <branch-name>
```

### 切换分支

```bash
git checkout <branch-name>
```

### 合并分支

```bash
git merge <branch-name>
```

## 常见问题

### 冲突解决

当合并分支时出现冲突，需要手动解决冲突后再提交。

### 撤销更改

```bash
# 撤销工作区更改
git checkout -- <file>
# 撤销暂存区更改
git reset HEAD <file>
# 撤销提交
git reset --soft HEAD~1
```
