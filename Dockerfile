FROM openjdk:17-oracle
RUN mkdir /opt/app
CMD ["./gradlew", "clean", "build"]
ARG JAR_FILE_PATH=build/libs/*.jar
COPY ${JAR_FILE_PATH} /opt/app/springproject.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","springproject.jar"]

# 기본 이미지를 선택합니다. 예: Ubuntu
FROM ubuntu:20.04

# 필요한 패키지 업데이트 및 설치
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
# Kubernetes의 apt 저장소 키를 추가합니다.
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Kubernetes APT 저장소를 추가합니다.
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# kubelet, kubeadm, kubectl을 설치합니다.
RUN apt-get update && \
    apt-get install -y kubelet kubeadm kubectl

# kubelet과 kubeadm을 설치 후 자동 업그레이드를 방지
RUN apt-mark hold kubelet kubeadm kubectl

# 필요한 추가 패키지
RUN apt-get install -y curl vim iproute2

# kubelet과 kubeadm을 제대로 실행할 수 있도록 설정
# (일반적으로 'cgroup' 설정이나 'hostname' 설정을 추가할 수 있음)

# 컨테이너에서 사용할 Kubernetes API 서버 주소 설정 (예시)
# RUN echo "KUBE_API_SERVER=https://<API_SERVER_IP>" >> /etc/environment

# 컨테이너의 작업 디렉토리 설정
WORKDIR /workspace

# 기본 명령어는 kubectl로 설정
CMD ["/bin/bash"]
