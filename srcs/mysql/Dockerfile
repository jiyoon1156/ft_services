FROM alpine:latest
ARG IP

# Installation
RUN apk update \
&& apk add mysql mysql-client && rm -rf /var/cache/apk/*

RUN mkdir -p /run/mysqld
# Copy initialisation script
COPY ./mariadb-server.cnf /etc/my.cnf.d/
# COPY ./mariadb-server.cnf /etc/mysql/
COPY ./init_docker.sh /tmp/
COPY ./init_mysql.sh /tmp/
COPY ./wordpress.sql /tmp/

# Add permission
# RUN chmod +x init_docker.sh
# RUN chmod +x init_mysql.sh
# RUN chmod +x init_docker.sh

RUN echo $IP > ip.txt
RUN export IP=$(cat /ip.txt)
RUN sed -i "s/192.168.99.120/$IP/g" /tmp/wordpress.sql

EXPOSE 3306

CMD sh /tmp/init_docker.sh