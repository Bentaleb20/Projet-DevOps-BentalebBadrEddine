# Utilisation d'une image Maven pour le build
FROM maven:3.8.6-openjdk-17 AS build

WORKDIR /app

# Copie des fichiers de configuration Maven
COPY pom.xml .
COPY src ./src

# Build de l'application
RUN mvn clean package -DskipTests

# Image finale avec OpenJDK
FROM openjdk:17-jre-slim

WORKDIR /app

# Copie du JAR depuis l'étape de build
COPY --from=build /app/target/projet-devops-1.0.0.jar app.jar

# Exécution de l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
