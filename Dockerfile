# Estágio 1: Build da Aplicação com Maven e Java 17
# A imagem base foi alterada para usar o JDK 17.
FROM maven:3-eclipse-temurin-17 AS builder

# Define o diretório de trabalho dentro do contêiner.
WORKDIR /app

# Copia o arquivo de configuração do Maven para o contêiner.
# Isso é feito primeiro para aproveitar o cache do Docker. Se o pom.xml não mudar,
# as dependências não serão baixadas novamente.
COPY pom.xml .

# Baixa todas as dependências do projeto.
RUN mvn dependency:go-offline

# Copia o restante do código-fonte da aplicação.
COPY src ./src

# Compila a aplicação e gera o arquivo .jar, pulando os testes.
RUN mvn clean package -DskipTests

# Estágio 2: Criação da Imagem Final de Execução
# A imagem JRE também foi alterada para a versão 17.
FROM eclipse-temurin:17-jre

# Define o diretório de trabalho.
WORKDIR /app

# Copia o arquivo .jar gerado no estágio de build para a imagem final.
# O nome do arquivo é renomeado para app.jar para facilitar a execução.
COPY --from=builder /app/target/*.jar app.jar

# Expõe a porta em que a aplicação Spring Boot será executada.
EXPOSE 5068

# Comando para iniciar a aplicação quando o contêiner for executado.
ENTRYPOINT ["java", "-jar", "app.jar"]
