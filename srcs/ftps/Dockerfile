FROM alpine:latest
ARG IP

# ftps
RUN apk update && apk upgrade
RUN apk add pure-ftpd --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

# SSL
RUN apk add --no-cache openssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=Korea/L=Seoul/O=innoaca/OU=42seoul/CN=jhur" -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem

RUN echo $IP > ip.txt

# ftps user setting
RUN mkdir -p ftps/user
RUN adduser --home=/ftps/user -D user
RUN echo "user:password" | chpasswd

EXPOSE 21 30020

CMD pure-ftpd -j -Y 2 -p 30020:30020 -P $(cat ip.txt)