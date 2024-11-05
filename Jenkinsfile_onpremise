pipeline {
    agent any

    tools {
        jdk "jdk17"
        gradle "Ga"
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhubToken') 
        IMAGE = 'pinkcandy02/springproject'  // Docker 이미지 이름
        NAMESPACE = 'default'  // 배포할 Kubernetes 네임스페이스 (필요 시 변경)
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-token',
                    url: 'https://github.com/suhh3262/spring-project.git'
            }
        }

        stage('Gradle Build') {
            steps {
                echo 'Gradle Build'
                sh 'chmod +x ./gradlew'  // 실행 권한 부여
                sh './gradlew build -x test'  // 테스트를 제외하고 빌드
            }
        }

        stage('Docker Image Build') {
            steps {
                echo 'Docker Image Build'
                dir("${env.WORKSPACE}") {
                    sh """
                        docker build -t pinkcandy02/springproject:$BUILD_NUMBER .
                        docker tag pinkcandy02/springproject:$BUILD_NUMBER pinkcandy02/springproject:latest
                    """
                }
            }
        }

        stage('Docker Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Docker Image Push') {
            steps {
                echo 'Docker Image Push'
                sh "docker push pinkcandy02/springproject:latest"
            }
        }

        stage('Cleaning up') {
            steps {
                echo 'Cleaning up unused Docker images on Jenkins server'
                sh """
                    docker rmi pinkcandy02/springproject:$BUILD_NUMBER
                    docker rmi pinkcandy02/springproject:latest
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes"
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'team4-k8s-master',  // Jenkins에서 설정한 SSH 서버 이름
                            transfers: [
                                sshTransfer(
                                    sourceFiles: '',  // 로컬 파일이 필요하지 않으므로 비워둠
                                    remoteDirectory: '',  // 원격 디렉토리 필요 없음
                                    execCommand: """
                                        kubectl set image deployment/knode-deployment knode=pinkcandy02/springproject:$BUILD_NUMBER --namespace=${NAMESPACE} && \
                                        kubectl rollout status deployment/knode-deployment --namespace=${NAMESPACE}
                                    """  // Deployment에 새 이미지를 적용하고 롤아웃 상태 확인
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }
    
    post {
        success {
            echo "Deployment to Kubernetes was successful!"
        }
        failure {
            echo "Deployment to Kubernetes failed."
        }
    }
}
