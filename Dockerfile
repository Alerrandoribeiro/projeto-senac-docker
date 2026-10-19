From maven:3.9.9-eclipse-temurin-21 as build
WORKDIR /app

# copiar pom.xml e baixar dependências
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Pulando testes
COPY src ./src
RUN mvn -B clean package -DskipTests

# Construindo a imagem final
From eclipse-temurin:21-jre-alpine
WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring
USER spring

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-XX:MaxRAMPercentage=75.0","-jar","app.jar"]