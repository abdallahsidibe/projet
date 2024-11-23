# Stage 1: Build the application using Maven
#FROM maven:3.9.3-eclipse-temurin-17 as builder
FROM maven:3-eclipse-temurin-17-alpine AS builder


# Set the working directory
WORKDIR /app

# Copy the pom.xml and install dependencies (Docker cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn package -DskipTests
#RUN mvn clean package -Dmaven.test.skip=true

# Stage 2: Create a minimal runtime environment
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/bank-service-0.0.1-SNAPSHOT.jar /app/bank-service.jar
#COPY target/bank-service-0.0.1-SNAPSHOT.jar bank-service.jar

EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/bank-service.jar"]
#ENTRYPOINT ["java", "-jar", "bank-service.jar"]
