FROM openjdk:17-alpine as build

WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

RUN ./gradlew clean build --no-daemon > /dev/null 2>&1 || true

COPY src src

RUN ./gradlew bootJar --no-daemon

FROM openjdk:17-alpine
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
