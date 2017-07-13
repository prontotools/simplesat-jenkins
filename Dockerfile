FROM jenkins:2.60.1

USER root
RUN apt-get update && apt-get install -y wget s3cmd

# install docker
RUN wget -qO- https://get.docker.com/ | sh

# install python 3.5
RUN apt-get install -y build-essential \
  python-dev \
  python-setuptools \
  checkinstall \
  libreadline-gplv2-dev \
  libncursesw5-dev \
  libssl-dev \
  libsqlite3-dev \
  tk-dev \
  libgdbm-dev \
  libc6-dev \
  libbz2-dev \
  postgresql

RUN cd /usr/src && \
  wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz && \
  tar xzf Python-3.6.1.tgz

RUN cd /usr/src/Python-3.6.1 && \
  ./configure && \
  make altinstall

RUN pip3.6 install awscli==1.11.2

# use python 2 to install fabric and awscli
RUN easy_install pip
RUN pip2.7 install Fabric==1.12.0

# install node
# code below from https://github.com/nodejs/docker-node/blob/4029a8f71920e1e23efa79602167014f9c325ba0/6.7/Dockerfile
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.7.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# install mjml runtime
RUN npm install -g mjml

# create directories for credential
RUN mkdir -p /root/.aws/
RUN mkdir -p /var/jenkins_home/.ssh/
