# Dockerfile
# Development
# VERSION   0.0.3
# how to run:
#   docker run --name dev --hostname dev --detach \
#       --privileged --publish a_port_for_sshd:22 openhpc/golang-dev-env
# how to build:
#   docker build --rm --tag openhpc/golang-dev-env .

FROM centos:7.2.1511

MAINTAINER Kim Goh <gaojingan [a@t] gmail.com>
LABEL name="Golang dev env image on Centos 7"

# Set Env
ENV container docker

RUN rpm --rebuilddb \
    && yum -y install yum-plugin-ovl deltarpm yum-utils glibc-common

RUN yum clean all \
    && yum -y makecache \
    && yum -y update \
    && yum -y install systemd-sysv initscripts \
    systemd-devel environment-modules git curl \
    openssh-server openssh-clients openssh net-tools \
    && yum clean all

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    rm -fr /usr/lib/systemd/system/systemd-update-utmp* \
    rm -fr /etc/sysconfig/network-scripts/ifcfg-e*;

VOLUME [ "/sys/fs/cgroup" ]
VOLUME /run /tmp

# set locale
RUN yum -y reinstall glibc-common; yum clean all
RUN localedef --delete-from-archive $(localedef --list-archive | grep -v "en_US" | xargs)
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# set TimeZone
RUN unlink /etc/localtime \
    && ln -s /usr/share/zoneinfo/Shanghai /etc/localtime

ENV GOLANG_VERSION 1.7
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ADD golang.module /usr/share/Modules/modulefiles/golang

# set sshd
# user: root
# passwd: gaoxing
RUN ssh-keygen -q -N "" -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -q -N "" -t rsa -b 2048 -f /root/.ssh/id_rsa \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
    && /bin/sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd \
    && sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config \
    && echo "UsePAM yes" >> /etc/ssh/sshd_config \
    && echo "UseDNS no" >> /etc/ssh/sshd_config \
    && echo "Port 22" >> /etc/ssh/sshd_config \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config \
    && echo 'TCPKeepAlive yes' >> /etc/ssh/sshd_config \
    && /bin/echo 'root:gaoxing' | chpasswd \
    && systemctl enable sshd

EXPOSE 22

CMD ["/usr/sbin/init"]
