FROM alpine

RUN apk update
RUN apk add wget

#install PHP
# RUN apk add php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

#install PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xvf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english /etc/phpmyadmin
RUN rm -rf /var/cache/apk/*
COPY ./config.inc.php /etc/phpmyadmin

EXPOSE 5000

#start phpmyadmin
CMD php -S 0.0.0.0:5000 -t /etc/phpmyadmin/