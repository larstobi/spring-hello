FROM maven:3-jdk-8-alpine as builder
ADD . /app
WORKDIR /app
RUN mvn package

FROM openjdk:8-jre-alpine
COPY --from=builder /app/target/app-1.0.jar /app.jar
ENV NAME="DefaultName"
EXPOSE 8080
CMD java -jar /app.jar
