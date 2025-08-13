# Base OpenJDK 24
FROM openjdk:24-jdk-slim

# Dependências
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /app

# Copia o JAR
COPY target/api-0.0.1-SNAPSHOT.jar app.jar

# Usuário não-root
RUN adduser --disabled-password --gecos '' appuser
RUN chown appuser:appuser /app/app.jar
USER appuser

# Porta exposta
EXPOSE 5068

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5068/actuator/health || exit 1

# Rodar aplicação
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
