# 技术文档项目

本项目用于存放常用技术和工具的使用与安装说明，旨在为开发团队提供统一的技术文档参考。

## 项目结构

```
tech-docs/                  # 项目根目录 
 ├── .gitignore              # Git忽略文件 
 ├── README.md               # 项目总览 
 ├── docs/                   # 核心文档目录 
 │   ├── dev-env/            # 开发环境配置 
 │   │   ├── linux/          # Linux环境 
 │   │   ├── macos/          # macOS环境 
 │   │   └── windows/        # Windows环境 
 │   ├── tools/              # 工具使用说明 
 │   │   ├── git/            # Git相关 
 │   │   ├── docker/         # Docker相关 
 │   │   ├── vscode/         # VSCode相关 
 │   │   └── jenkins/        # Jenkins相关 
 │   ├── languages/          # 编程语言相关 
 │   │   ├── python/         # Python 
 │   │   ├── java/           # Java 
 │   │   └── go/             # Go 
 │   └── frameworks/         # 框架使用说明 
 │       ├── springboot/     # SpringBoot 
 │       └── django/         # Django 
 └── assets/                 # 静态资源（截图、配置文件等） 
     ├── images/             # 截图/示意图 
     └── configs/            # 配置文件模板
```

## 文档内容

### 开发环境配置
- **Linux**: Linux 系统开发环境搭建与配置
- **macOS**: macOS 系统开发环境搭建与配置
- **Windows**: Windows 系统开发环境搭建与配置

### 工具使用说明
- **Git**: Git 版本控制工具的使用指南
- **Docker**: Docker 容器化工具的使用指南
- **VSCode**: Visual Studio Code 编辑器的配置与使用
- **Jenkins**: Jenkins 持续集成工具的配置与使用

### 编程语言相关
- **Python**: Python 语言的使用指南与最佳实践
- **Java**: Java 语言的使用指南与最佳实践
- **Go**: Go 语言的使用指南与最佳实践

### 框架使用说明
- **SpringBoot**: Spring Boot 框架的使用指南
- **Django**: Django 框架的使用指南

## 如何贡献

1. Fork 本项目
2. 创建新的分支
3. 编写或修改文档
4. 提交 Pull Request

## 注意事项

- 文档内容应保持简洁明了
- 提供清晰的安装步骤和使用示例
- 定期更新文档以保持时效性
- 使用 Markdown 格式编写文档
