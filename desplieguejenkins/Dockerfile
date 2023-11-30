FROM jenkins/jenkins:jdk21
#cat /etc/*release
WORKDIR /tmp
run curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
run unzip awscliv2.zip
USER root
run  ./aws/install
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.6 docker-workflow:1.29"

