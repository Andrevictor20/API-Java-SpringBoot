# Stage 1: Build do JAR
FROM maven:3.9.2-openjdk-24-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Imagem final
FROM openjdk:24-jdk-slim
WORKDIR /app

# Copia o JAR do build stage
COPY --from=build /app/target/api-0.0.1-SNAPSHOT.jar app.jar

# Usuário não-root
RUN adduser --disabled-password --gecos '' appuser
RUN chown appuser:appuser /app/app.jar
USER appuser

EXPOSE 5068

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5068/actuator/health || exit 1

ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
