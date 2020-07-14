FROM alpine

RUN apk update
RUN apk add --no-cache nginx
RUN adduser -D -g 'www' www
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html
# SSL
RUN apk add --no-cache openssl
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=Korea/L=Seoul/O=innoaca/OU=42seoul/CN=jhur" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt; 

EXPOSE 80 443
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]

# COPY init.sh   ./init.sh
# CMD sh ./init.sh
