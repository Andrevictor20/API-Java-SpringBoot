# Usando a imagem OpenJDK 24 para ARM
FROM openjdk:24-jdk-slim-bookworm

# Diretório de trabalho
WORKDIR /app

# Copia o JAR compilado para o container
COPY target/api-0.0.1-SNAPSHOT.jar app.jar

# Cria um usuário não-root para segurança
RUN adduser --disabled-password --gecos '' appuser
RUN chown appuser:appuser /app/app.jar
USER appuser

# Expõe a porta da aplicação
EXPOSE 5068

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5068/actuator/health || exit 1

# Comando para executar a aplicação
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
