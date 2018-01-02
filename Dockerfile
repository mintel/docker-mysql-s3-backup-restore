FROM alpine:3.7

MAINTAINER Nick

RUN apk add --no-cache py-pip py-setuptools ca-certificates gnupg mariadb-client bash
RUN pip install s3cmd
RUN rm -rf /var/cache/apk/*

ADD files/s3cfg /opt/docker-mysql-s3/.s3cfg
ADD files/bootstrap /opt/docker-mysql-s3/bootstrap
ADD files/restore /opt/docker-mysql-s3/restore
ADD files/backup /opt/docker-mysql-s3/backup
ADD files/settings /opt/docker-mysql-s3/settings

RUN chmod +x /opt/docker-mysql-s3/bootstrap && \
    chmod +x /opt/docker-mysql-s3/restore && \
    chmod +x /opt/docker-mysql-s3/backup

WORKDIR /opt/docker-mysql-s3
ENTRYPOINT ["/opt/docker-mysql-s3/bootstrap"]
