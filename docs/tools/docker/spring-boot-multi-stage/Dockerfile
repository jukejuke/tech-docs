# 第一阶段：构建阶段
FROM maven:3.9.6-eclipse-temurin-21 AS build

# 设置工作目录
WORKDIR /app

# 复制 Maven 配置文件
COPY pom.xml .

# 下载依赖
RUN mvn dependency:go-offline -B

# 复制源代码
COPY src src

# 构建应用
RUN mvn package -DskipTests

# 第二阶段：运行阶段
FROM eclipse-temurin:21-jre-alpine AS run

# 设置工作目录
WORKDIR /app

# 从构建阶段复制构建好的 JAR 文件
COPY --from=build /app/target/*.jar app.jar

# 暴露端口
EXPOSE 8080

# 运行应用
ENTRYPOINT ["java", "-jar", "app.jar"]