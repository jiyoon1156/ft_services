FROM alpine:latest

RUN apk update && apk add influxdb
RUN rm -rf /var/cache/apk/*

COPY ./influxdb.conf /etc/

EXPOSE 8086

ENTRYPOINT ["/usr/sbin/influxd"]