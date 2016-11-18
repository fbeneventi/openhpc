FROM alpine:3.4

MAINTAINER Kim Goh <gaojingan [at] gmail.com>

RUN echo 'https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.4/main' > /etc/apk/repositories \
    && echo 'https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.4/community' >> /etc/apk/repositories \
    && apk --update --no-cache add bash rsync \
    && rm -fr /var/cache/apk/*

ENTRYPOINT ["rsync"]
CMD []
