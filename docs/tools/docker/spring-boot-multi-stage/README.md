# Spring Boot 多阶构建 Docker 示例

本示例展示了如何使用 Docker 多阶构建来构建和运行 Spring Boot 应用程序，使用 JDK 21。

## 多阶构建的优势

1. **减小镜像大小**：使用多阶构建可以只包含运行时所需的依赖，而不包含构建工具和中间文件
2. **提高安全性**：运行时镜像不包含构建工具，减少了潜在的安全漏洞
3. **简化构建过程**：使用单一 Dockerfile 完成构建和打包过程

## 构建和运行步骤

### 1. 构建 Docker 镜像

```bash
docker build -t spring-boot-app .
```

### 2. 运行容器

```bash
docker run -p 8080:8080 spring-boot-app
```

## Dockerfile 说明

### 第一阶段：构建阶段

- 使用 `eclipse-temurin:21-jdk-alpine` 作为基础镜像，包含 JDK 21
- 设置工作目录为 `/app`
- 复制 Maven 配置文件和包装器
- 下载依赖
- 复制源代码
- 构建应用

### 第二阶段：运行阶段

- 使用 `eclipse-temurin:21-jre-alpine` 作为基础镜像，只包含 JRE 21
- 设置工作目录为 `/app`
- 从构建阶段复制构建好的 JAR 文件
- 暴露端口 8080
- 运行应用

## 项目结构要求

本示例假设项目使用 Maven 构建，并且具有以下结构：

```
.
├── src
└── pom.xml
```

## 注意事项

1. 确保 `pom.xml` 文件正确配置，特别是打包方式和依赖管理
2. 如需使用其他构建工具（如 Gradle），需要相应调整 Dockerfile
3. 可以根据实际需求调整 JVM 参数和环境变量
4. 对于生产环境，建议使用更具体的版本标签，而不是 `latest`