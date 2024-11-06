FROM openjdk:17-oracle
# 애플리케이션을 빌드할 디렉토리 생성
WORKDIR /opt/app

# Gradle wrapper 및 소스 코드를 Docker 이미지로 복사
COPY gradlew /opt/app/gradlew
COPY gradle /opt/app/gradle
COPY build.gradle /opt/app/build.gradle
COPY settings.gradle /opt/app/settings.gradle
COPY src /opt/app/src

# Gradle wrapper에 실행 권한 부여
RUN chmod +x /opt/app/gradlew

# Gradle 빌드 명령어 실행 (JAR 파일 생성)
RUN ./gradlew clean build

# 빌드된 JAR 파일을 Docker 컨테이너로 복사 (JAR 파일 경로에 맞게 설정)
COPY build/libs/*.jar /opt/app/springproject.jar

# 애플리케이션 포트 노출
EXPOSE 8081

# 컨테이너 실행 시 실행할 명령어
ENTRYPOINT ["java", "-jar", "/opt/app/springproject.jar"]
