# Dockerfile
# Development
# VERSION   0.0.2
# how to run:
#   ip:hostPort:containerPort
#   docker run --name pbspro --hostname pbspro --detach --privileged --publish 2222:22 --publish 5432:5432 openhpc/pbspro
# how to build:
#   docker build --rm --tag openhpc/pbspro .

FROM centos:7.2.1511
ENV container=docker

MAINTAINER Kim Goh <gaojingan@gmail.com>
LABEL name="PBS Pro Base Image on Centos 7"

RUN rpm --rebuilddb \
    && yum -y install yum-plugin-ovl deltarpm yum-utils
    
RUN yum clean all \
    && yum -y makecache \
    && yum -y update \
    && yum -y install  systemd-sysv initscripts \
    systemd-devel postfix git \
    postgresql-devel postgresql-server \
    postgresql postgresql-contrib pwgen \
    && yum clean all

# RUN su - postgres -c "PGDATA=/var/lib/pgsql/data initdb"
RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/pgsql/data/pg_hba.conf \
    && echo "listen_addresses = '*'" >> /var/lib/pgsql/data/postgresql.conf

# set locale
RUN yum -y reinstall glibc-common && yum clean all
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# set TimeZone
RUN unlink /etc/localtime \
    && ln -s /usr/share/zoneinfo/Shanghai /etc/localtime

VOLUME /sys/fs/cgroup /run /tmp

RUN cd /root && git clone https://github.com/PBSPro/pbspro

RUN cd /root/pbspro \
    && yum-builddep -y pbspro.spec \
    && ./autogen.sh \
    && ./configure --prefix=/opt/pbs --libexecdir=/opt/pbs/libexec \
    && make dist \
    && mkdir -p /root/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} \
    && cp $(ls |grep pbspro|grep tar.gz) /root/rpmbuild/SOURCES/ \
    && cp pbspro.spec /root/rpmbuild/SPECS/ \
    && cd /root/rpmbuild \
    && rpmbuild -ba SPECS/pbspro.spec \
    && rm -fr /root/pbspro /root/rpmbuild/BUILD/*
