# Added in support for NEO4J 


# Copyright (c) 2012-2016 Codenvy, S.A.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# Contributors:
# Codenvy, S.A. - initial API and implementation
FROM ubuntu
EXPOSE 4403 8000 8080 9876 22
RUN apt-get update && \
    apt-get -y install sudo openssh-server procps wget unzip mc curl subversion software-properties-common python-software-properties && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -u 1000 -G users,sudo -d /home/user --shell /bin/bash -m user && \
    echo "secret\nsecret" | passwd user && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    sudo apt-get install git -y && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

USER user

LABEL che:server:8080:ref=tomcat8 che:server:8080:protocol=http 
LABEL che:server:8000:ref=tomcat8-debug che:server:8000:protocol=http 
LABEL che:server:9876:ref=codeserver che:server:9876:protocol=http


ENV MAVEN_VERSION=3.3.9 \
    JAVA_VERSION=8u45 \
    JAVA_VERSION_PREFIX=1.8.0_45 \
    TOMCAT_HOME=/home/user/tomcat8

ENV JAVA_HOME=/opt/jdk$JAVA_VERSION_PREFIX \
M2_HOME=/home/user/apache-maven-$MAVEN_VERSION

ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

RUN mkdir /home/user/cbuild /home/user/tomcat8 /home/user/apache-maven-$MAVEN_VERSION && \
  wget \
  --no-cookies \
  --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  -qO- \
  "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-b14/jdk-$JAVA_VERSION-linux-x64.tar.gz" | sudo tar -zx -C /opt/ && \
  wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/user/apache-maven-$MAVEN_VERSION/
ENV TERM xterm

RUN wget -qO- "http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz" | tar -zx --strip-components=1 -C /home/user/tomcat8 && \
    rm -rf /home/user/tomcat8/webapps/*


ENV LANG en_GB.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export JAVA_HOME=/opt/jdk$JAVA_VERSION_PREFIX\nexport M2_HOME=/home/user/apache-maven-$MAVEN_VERSION\nexport TOMCAT_HOME=/home/user/tomcat8\nexport PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH" >> /home/user/.bashrc && \
    sudo locale-gen en_US.UTF-8
    

# neo4j setup
RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key > /tmp/neotechnology.gpg.key && \
    sudo apt-key add /tmp/neotechnology.gpg.key

RUN echo 'deb http://debian.neo4j.org/repo stable/' > /tmp/neo4j.list && \
    sudo cp /tmp/neo4j.list /etc/apt/sources.list.d/neo4j.list

RUN sudo apt-get update
RUN sudo apt-get install -y neo4j

WORKDIR /var/lib/neo4j

RUN sudo mv data /data \
    && sudo ln --symbolic /data

VOLUME ['/data']

# expose the port
RUN sudo sed -i '/0.0.0.0:7474/s/^#//' /etc/neo4j/neo4j.conf 


EXPOSE 7474 7473 7687 3000
LABEL che:server:7474:ref="Neo4j Browser" che:server:7474:protocol=http
LABEL che:server:7473:ref="Neo4j Browser (HTTPS)" che:server:7473:protocol=https
LABEL che:server:7687:ref="Neo4j Bolt" che:server:7687:protocol=http
LABEL che:server:3000:ref=NodeJS che:server:3000:protocol=http


# node install details
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN sudo apt-get install -y nodejs


WORKDIR /projects



CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
