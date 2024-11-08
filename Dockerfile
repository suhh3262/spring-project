FROM openjdk:17-oracle
RUN apt-get update && apt-get install -y openssh-server
CMD ["./gradlew", "clean", "build"]
CMD ["service", "ssh", "start"]
ARG JAR_FILE_PATH=build/libs/*.jar
COPY ${JAR_FILE_PATH} springproject.jar
EXPOSE 8081
EXPOSE 22
ENTRYPOINT ["java","-jar","springproject.jar"]
