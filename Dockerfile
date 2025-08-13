# Estágio 1: Build da Aplicação com Maven e Java 17
FROM maven:3-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
# O arquivo .env é copiado aqui para ser usado, se necessário, durante o build
COPY .env .
RUN mvn clean package -DskipTests

# Estágio 2: Criação da Imagem Final de Execução
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copia o arquivo .jar gerado no estágio de build para a imagem final.
COPY --from=builder /app/target/*.jar app.jar

# CORREÇÃO: Copia o arquivo .env do estágio de build para a imagem final.
# Agora a aplicação poderá encontrá-lo durante a execução.
COPY --from=builder /app/.env .

# Expõe a porta em que a aplicação Spring Boot será executada.
EXPOSE 5068

# Comando para iniciar a aplicação quando o contêiner for executado.
ENTRYPOINT ["java", "-jar", "app.jar"]
