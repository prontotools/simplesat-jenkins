# SimpleSat Jenkins

Docker Hub: [prontotools/simplesat-jenkins](https://hub.docker.com/r/prontotools/simplesat-jenkins/)

To run the Jenkins: `docker-compose up`

To build the image: `docker build -t prontotools/simplesat-jenkins .`

To push the image: `docker push prontotools/simplesat-jenkins`

## Setting up on Server

1. git clone from this repository via
```
git clone git@github.com:prontotools/simplesat-jenkins.git
```

2. Start jenkins via docker-compose by
```
cd simplesat-jenkins
docker-compose up -d
```

3. We need to change pg_hba.conf in `/etc/postgresql/9.x/main/` like below in order to let Python able to use postgresql to run test
```
local   all             postgres                                trust
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```

4. Restart postgres via `service postgresql restart`
