# Base OpenJDK 24
FROM openjdk:24-jdk-slim

# Instala dependências necessárias
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /app

# Copia o JAR já buildado manualmente
COPY target/api-0.0.1-SNAPSHOT.jar app.jar

# Cria usuário não-root
RUN adduser --disabled-password --gecos '' appuser
RUN chown appuser:appuser /app/app.jar
USER appuser

# Expõe a porta da aplicação
EXPOSE 5068

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5068/actuator/health || exit 1

# Comando para executar
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
