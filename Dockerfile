FROM openjdk:17-oracle
CMD ["./gradlew", "clean", "build"]
ARG JAR_FILE_PATH=build/libs/*.jar
COPY ${JAR_FILE_PATH} springproject.jar
EXPOSE 8081
EXPOSE 22
RUN service ssh start
ENTRYPOINT ["java","-jar","springproject.jar"]
