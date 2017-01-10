# openhpc/rsync:latest [![CircleCI](https://circleci.com/gh/lcnja/openhpc/tree/master.svg?style=svg)](https://circleci.com/gh/lcnja/openhpc/tree/master) [![Build Status](https://travis-ci.org/lcnja/openhpc.svg?branch=master)](https://travis-ci.org/lcnja/openhpc) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# openhpc/golang-dev-env:latest
#### how to run directly:
```bash
docker run \
   --name dev \
   --hostname dev \
   --detach \
   --volume /sys/fs/cgroup:/sys/fs/cgroup:ro --volume /run \
   --cap-add SYS_ADMIN \
   --publish a_port_for_sshd:22 \
   openhpc/golang-dev-env
```
##### how to run via docker-compose:
```yaml
version: '2'
services:
  golang:
    build: .
    image: openhpc/golang-dev-env:latest
    container_name: golang
    hostname: golang
    restart: on-failure:2
    tty: true
    stdin_open: true
    # privileged: true
    cap_add:     
      - SYS_ADMIN
    mem_limit: 2048M
    volumes:
      - /var/lib/docker/golang-dev-env/root/work:/root/work
    ports:
      - "21022:22"
    networks:
      dev:
        ipv4_address: 172.21.1.11
    environment:
      Author: "Kim Goh"
    dns: 8.8.8.8
networks:
  dev:
    driver: bridge
    driver_opts:
      com.docker.network.enable_ipv6: "false"
    ipam:
      driver: default
      config:
        - subnet: 172.21.1.0/24
          gateway: 172.21.1.1
```

###### how to build:
```bash
docker build --rm --tag openhpc/golang-dev-env .
```
###### how to add/rm golang env:
```bash
module add/rm golang/1.7
```
