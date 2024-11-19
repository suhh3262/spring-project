FROM jenkins/jenkins:latest
ARG DOCKER_GID=1000
USER root

# docker install
COPY scripts/install-docker.sh .
RUN chmod u+x install-docker.sh && \
    ./install-docker.sh

COPY scripts/install-docker-compose.sh .
RUN chmod u+x install-docker-compose.sh && \
    ./install-docker-compose.sh

# set jenkins user to host docker group
RUN /usr/sbin/groupadd -g ${DOCKER_GID:-1000} -f docker && \
    /usr/sbin/usermod -aG docker jenkins

USER jenkins

