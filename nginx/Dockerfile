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

#SSH
RUN apk add --no-cache openssh
&& sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config \
&& echo 'root:0000' | chpasswd \
&& ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
&& ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
&& mkdir -p /var/run/sshd

# 22 port is being already used in MAC
EXPOSE 80 443 30022

# ENTRYPOINT ["nginx"]
# CMD ["-g", "daemon off;"]
# CMD ["/usr/sbin/sshd","-D"]

COPY init.sh ./init.sh
CMD sh ./init.sh
