# OpenJDK 17을 기반으로 사용
FROM openjdk:17-oracle

ARG JAR_FILE_PATH=build/libs/*.jar

# Jenkins 빌드 컨텍스트 내에 있는 gradle 관련 파일들을 컨테이너로 복사
COPY gradlew /var/jenkins_home/workspace/spring-project/gradlew
COPY gradle /var/jenkins_home/workspace/spring-project/gradle
COPY build.gradle /var/jenkins_home/workspace/spring-project/build.gradle
COPY settings.gradle /var/jenkins_home/workspace/spring-project/settings.gradle
COPY src /var/jenkins_home/workspace/spring-project/src

# Gradle wrapper에 실행 권한 부여
RUN chmod +x /var/jenkins_home/workspace/spring-project/gradlew

# Gradle 빌드 실행 (JAR 파일 생성)
RUN /var/jenkins_home/workspace/spring-project/gradlew clean build

# 빌드된 JAR 파일을 Docker 컨테이너로 복사
COPY build/libs/*.jar /var/jenkins_home/workspace/spring-project/build/libs/springproject.jar

# 애플리케이션 포트 노출
EXPOSE 8081

# 컨테이너 실행 시 실행할 명령어
ENTRYPOINT ["java", "-jar", "/var/jenkins_home/workspace/spring-project/build/libs/springproject.jar"]
