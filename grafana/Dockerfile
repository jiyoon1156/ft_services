FROM alpine:latest

RUN apk update
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache
RUN rm -rf /var/cache/apk/*

EXPOSE 3000
CMD ["/usr/sbin/grafana-server", "--homepath=/usr/share/grafana"]