# Multi-stage build para Spring Boot
FROM maven:3.9-openjdk-17-slim AS build

WORKDIR /app

# Copiar arquivos de configuração do Maven
COPY pom.xml .
COPY src ./src

# Build da aplicação
RUN mvn clean package -DskipTests

# Imagem final
FROM openjdk:17-jdk-slim

WORKDIR /app

# Instalar curl para health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copiar o JAR da aplicação
COPY --from=build /app/target/*.jar app.jar

# Criar diretório para logs
RUN mkdir -p /app/logs

# Expor porta
EXPOSE 8080

# Variáveis de ambiente
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Comando para executar a aplicação
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

