FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# First copy ONLY pom.xml (helps layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Then copy src (separate step to debug)
COPY src ./src
RUN ls -laR src/  # Debug: List all files

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk-jammy
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
