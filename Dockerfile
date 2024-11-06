FROM openjdk:17-oracle
RUN mkdir /opt/app
CMD ["./gradlew", "clean", "build"]
ARG JAR_FILE_PATH=build/libs/*.jar
COPY ${JAR_FILE_PATH} springproject.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","springproject.jar"]
