# Java 常用 Jar 包文档

本文档列出了 Java 开发中常用的 Jar 包及其使用说明。

## 核心 Java 库

### JDK 核心库
- **rt.jar**: Java 运行时核心库
- **tools.jar**: Java 开发工具库

## 构建工具

### Maven 依赖管理

#### 常用依赖

| 依赖名称 | Group ID | Artifact ID | 版本 | 用途 |
|---------|---------|------------|------|------|
| Spring Boot | org.springframework.boot | spring-boot-starter | 3.2.0+ | Spring Boot 核心依赖 |
| Spring Web | org.springframework.boot | spring-boot-starter-web | 3.2.0+ | Web 应用开发 |
| Spring Data JPA | org.springframework.boot | spring-boot-starter-data-jpa | 3.2.0+ | JPA 数据访问 |
| MyBatis | org.mybatis.spring.boot | mybatis-spring-boot-starter | 3.0.0+ | MyBatis ORM 框架 |
| MySQL 驱动 | com.mysql | mysql-connector-j | 8.0.30+ | MySQL 数据库驱动 |
| H2 数据库 | com.h2database | h2 | 2.2.224+ | 内存数据库 |

### Gradle 依赖管理

```gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter:3.2.0'
    implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa:3.2.0'
    implementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter:3.0.0'
    implementation 'com.mysql:mysql-connector-j:8.0.30'
    runtimeOnly 'com.h2database:h2:2.2.224'
}
```

## 常用工具库

### 日志框架
- **Logback**: `ch.qos.logback:logback-classic:1.4.0+` - 常用日志实现
- **Log4j2**: `org.apache.logging.log4j:log4j-core:2.20.0+` - 高性能日志框架
- **SLF4J**: `org.slf4j:slf4j-api:2.0.0+` - 日志门面

### JSON 处理
- **Jackson**: `com.fasterxml.jackson.core:jackson-databind:2.15.0+` - JSON 序列化/反序列化
- **Gson**: `com.google.code.gson:gson:2.10.0+` - Google JSON 库
- **Fastjson**: `com.alibaba:fastjson:2.0.0+` - 阿里巴巴 JSON 库

### HTTP 客户端
- **OkHttp**: `com.squareup.okhttp3:okhttp:4.10.0+` - 现代 HTTP 客户端
- **Apache HttpClient**: `org.apache.httpcomponents.client5:httpclient5:5.3.0+` - 传统 HTTP 客户端
- **RestTemplate**: Spring 内置 HTTP 客户端

### 工具库
- **Guava**: `com.google.guava:guava:32.0.0+` - Google 核心工具库
- **Apache Commons**: `org.apache.commons:commons-lang3:3.12.0+` - 通用工具类
- **Lombok**: `org.projectlombok:lombok:1.18.28+` - 减少样板代码
- **Joda-Time**: `joda-time:joda-time:2.12.5+` - 日期时间处理

### 测试框架
- **JUnit 5**: `org.junit.jupiter:junit-jupiter:5.10.0+` - 单元测试框架
- **Mockito**: `org.mockito:mockito-core:5.0.0+` - 模拟测试框架
- **AssertJ**: `org.assertj:assertj-core:3.24.0+` - 流式断言库
- **TestNG**: `org.testng:testng:7.8.0+` - 测试框架

### 安全库
- **BCrypt**: `org.springframework.security:spring-security-crypto:6.0.0+` - 密码加密
- **JWT**: `io.jsonwebtoken:jjwt:0.11.5+` - JSON Web Token
- **Apache Shiro**: `org.apache.shiro:shiro-core:1.10.0+` - 安全框架

### 缓存库
- **Redis Client**: `redis.clients:jedis:4.4.0+` - Redis 客户端
- **Caffeine**: `com.github.ben-manes.caffeine:caffeine:3.1.0+` - 本地缓存
- **Ehcache**: `org.ehcache:ehcache:3.10.0+` - 企业级缓存

### 消息队列
- **RabbitMQ Client**: `com.rabbitmq:amqp-client:5.17.0+` - RabbitMQ 客户端
- **Kafka Client**: `org.apache.kafka:kafka-clients:3.5.0+` - Kafka 客户端

### 其他常用库
- **Apache POI**: `org.apache.poi:poi:5.2.0+` - Office 文档处理
- **iText**: `com.itextpdf:itext7-core:7.2.0+` - PDF 处理
- **Apache Commons IO**: `commons-io:commons-io:2.11.0+` - IO 操作工具
- **Google Zxing**: `com.google.zxing:core:3.5.0+` - 二维码生成/解析

## 使用示例

### Maven 依赖配置示例

```xml
<dependencies>
    <!-- Spring Boot 核心 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
        <version>3.2.0</version>
    </dependency>
    
    <!-- Web 支持 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>3.2.0</version>
    </dependency>
    
    <!-- 数据库 -->
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>3.0.0</version>
    </dependency>
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <version>8.0.30</version>
    </dependency>
    
    <!-- 工具库 -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.28</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.15.0</version>
    </dependency>
    
    <!-- 测试 -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.0</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### Gradle 依赖配置示例

```gradle
dependencies {
    // Spring Boot 核心
    implementation 'org.springframework.boot:spring-boot-starter:3.2.0'
    implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'
    
    // 数据库
    implementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter:3.0.0'
    implementation 'com.mysql:mysql-connector-j:8.0.30'
    
    // 工具库
    compileOnly 'org.projectlombok:lombok:1.18.28'
    annotationProcessor 'org.projectlombok:lombok:1.18.28'
    implementation 'com.fasterxml.jackson.core:jackson-databind:2.15.0'
    
    // 测试
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.0'
}
```

## 版本管理建议

1. **使用依赖管理工具**：优先使用 Maven 或 Gradle 进行依赖管理
2. **版本一致性**：确保相关依赖版本兼容
3. **定期更新**：定期检查并更新依赖版本，修复安全漏洞
4. **锁定版本**：在生产环境中锁定依赖版本，避免意外更新
5. **依赖分析**：使用工具分析依赖树，避免依赖冲突

## 常见问题

### 依赖冲突
- **症状**：运行时出现类加载错误或方法找不到
- **解决方法**：使用 `mvn dependency:tree` 分析依赖树，排除冲突依赖

### 版本不兼容
- **症状**：编译错误或运行时异常
- **解决方法**：检查依赖版本兼容性，参考官方文档

### 包大小问题
- **症状**：打包后 jar 文件过大
- **解决方法**：使用依赖分析工具，移除不必要的依赖

## 参考资源

- [Maven 中央仓库](https://mvnrepository.com/)
- [Spring Boot 依赖版本](https://spring.io/projects/spring-boot)
- [Java 依赖管理最佳实践](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)
