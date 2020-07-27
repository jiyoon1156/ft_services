FROM alpine
ARG IP

RUN apk update
RUN apk add wget
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session
#install WordPress
RUN wget -c https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress/ /etc/
RUN rm -rf /var/cache/apk/*
COPY ./wp-config.php /etc/wordpress

RUN echo $IP > ip.txt
RUN export IP=$(cat /ip.txt)
RUN sed -i "s/MINIKUBE_IP/$IP/g" /etc/wordpress/wp-config.php

EXPOSE 5050

#start wordpress
CMD php -S 0.0.0.0:5050 -t /etc/wordpress/
