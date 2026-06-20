# --- Stage 1: Build the Application (The Builder) ---
FROM maven:3.8.4-openjdk-11-slim AS builder

# Set working directory inside the container
WORKDIR /app

# Copy the pom.xml and source code into the container
COPY pom.xml .
COPY src ./src

# Build the WAR file entirely inside the container
RUN mvn clean package

# --- Stage 2: Production Server (The Runner) ---
FROM tomcat:9.0-jdk11-openjdk-slim

# Remove default Tomcat apps for maximum security and performance
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy ONLY the compiled WAR from Stage 1 into the Tomcat webapps directory
COPY --from=builder /app/target/elite-app.war /usr/local/tomcat/webapps/ROOT.war

# Expose the standard web port
EXPOSE 8080

# Start the Tomcat server
CMD ["catalina.sh", "run"]
