FROM jenkins/jenkins:jdk21
#cat /etc/*release
WORKDIR /tmp
run curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
run unzip awscliv2.zip
USER root
run  ./aws/install

run apt update

run apt install python3-full -y
run apt install pip -y 
run  pip install checkov --break-system-packages
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.6 docker-workflow:1.29"

#apt install wget
#wget https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz
#tar -xf Python-3.11.3.tgz
#cd Python-3.11.3 && ./configure --enable-optimizations
#make -j 12
