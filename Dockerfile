FROM openjdk:17-oracle
CMD ["./gradlew", "clean", "build"]
ARG JAR_FILE_PATH=build/libs/*.jar
COPY ${JAR_FILE_PATH} springproject.jar
EXPOSE 8081
EXPOSE 22
ENTRYPOINT ["/bin/bash", "-c", "service ssh start && java -jar springproject.jar"]
