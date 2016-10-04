FROM jenkins:2.7.4

USER root
RUN apt-get update && apt-get install -y wget
RUN wget -qO- https://get.docker.com/ | sh
RUN apt-get install -y build-essential \
        checkinstall \
        libreadline-gplv2-dev \
        libncursesw5-dev \
        libssl-dev \
        libsqlite3-dev \
        tk-dev \
        libgdbm-dev \
        libc6-dev \
        libbz2-dev
RUN cd /usr/src && wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz && tar xzf Python-3.5.2.tgz
RUN cd /usr/src/Python-3.5.2 && ./configure && make altinstall
RUN apt-get install -y python-pip
