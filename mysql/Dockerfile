FROM alpine:latest
ARG IP

# Installation
RUN apk update \
&& apk add mariadb mariadb-client && apk add --no-cache --upgrade bash \
&& rm -rf /var/cache/apk/*

# Copy initialisation script
COPY ./my.cnf /etc/mysql/
#COPY ./my.cnf /etc/my.cnf.d/ ????
COPY ./init_docker.sh /tmp/
COPY ./init_mysql.sh /tmp/
COPY wordpress.sql /tmp/

# Add permission
RUN chmod +x init_docker.sh
RUN chmod +x init_mysql.sh
RUN chmod +x init_docker.sh

RUN echo $IP > ip.txt
RUN export IP=$(cat /ip.txt)
RUN sed -i "s/MINIKUBE_IP/$IP/g" /wordpress.sql

EXPOSE 3306

CMD sh /tmp/init_docker.sh