# Dockerfile
# Development
# VERSION   0.0.2
# how to run:
#   ip:hostPort:containerPort
#   docker run --name pbspro --hostname pbspro --detach --privileged --publish 2222:22 --publish 5432:5432 openhpc/pbspro
# how to build:
#   docker build --rm --tag openhpc/pbspro .

FROM centos:7.2.1511

ENV container docker

MAINTAINER Kim Goh <gaojingan@gmail.com>
LABEL name="PBS Pro Base Image on Centos 7"

RUN rpm --rebuilddb \
    && yum -y install yum-plugin-ovl deltarpm yum-utils glibc-common
    
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

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# set locale
RUN yum -y reinstall glibc-common; yum clean all; localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
    
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# set TimeZone
RUN unlink /etc/localtime \
    && ln -s /usr/share/zoneinfo/Shanghai /etc/localtime

VOLUME [ "/sys/fs/cgroup" ]

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

CMD ["/usr/sbin/init"]
