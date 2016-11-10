# Dockerfile
# Development
# VERSION   0.0.2
# how to run:
#   ip:hostPort:containerPort
#   docker run --name pbspro --hostname pbspro --detach --privileged --publish 2222:22 --publish 5432:5432 openhpc/pbspro
# how to build:
#   docker build --rm --tag openhpc/pbspro .

FROM centos:latest
ENV container=docker

MAINTAINER Kim Goh <gaojingan@gmail.com>
LABEL name="PBS Pro Base Image on Centos 7"

# ADD CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum clean all \
    && yum -y makecache \
    && yum -y update \
    && yum -y install \
    bash-completion curl wget git \
    sudo rsync vim perl unzip \
    systemd-sysv initscripts net-tools \
    openssh-server openssh-clients \
    systemd-devel postfix \
    postgresql-devel postgresql-server \
    postgresql postgresql-contrib pwgen \
    environment-modules \
    && yum clean all

#Sudo requires a tty. fix that.
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers
RUN su - postgres -c "PGDATA=/var/lib/pgsql/data initdb"
RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/pgsql/data/pg_hba.conf \
    && echo "listen_addresses = '*'" >> /var/lib/pgsql/data/postgresql.conf

# set locale
RUN yum -y reinstall glibc-common && yum clean all
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

# set TimeZone
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Shanghai /etc/localtime

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# set sshd
# user: root
# passwd: gaoxing
RUN ssh-keygen -q -N "" -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -b 2048 -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN /bin/echo 'root:gaoxing' |chpasswd

RUN /bin/sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd

RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config \
    && echo "UseDNS no" >> /etc/ssh/sshd_config \
    && echo "Port 22" >> /etc/ssh/sshd_config

EXPOSE 22 5432
VOLUME /sys/fs/cgroup /run /tmp

RUN systemctl enable sshd postgresql

RUN cd /root && git clone https://github.com/PBSPro/pbspro
# ADD pbspro /root/pbspro
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
    && yum -y install /root/rpmbuild/RPMS/x86_64/$(ls  /root/rpmbuild/RPMS/x86_64/|grep server)

ADD StartPBS.sh /root/StartPBS.sh
RUN chmod 755 /root/StartPBS.sh

ENV HOME /root
WORKDIR /root

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

ADD golang /usr/share/Modules/modulefiles/golang

CMD ["/usr/sbin/init"]
