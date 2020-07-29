FROM alpine:latest

RUN apk update
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /etc/grafana/provisioning/dashboards
COPY ./dashboards /var/lib/grafana/dashboards/

COPY ./provisioning/dashboards.yaml /usr/share/grafana/conf/provisioning/dashboards
COPY ./provisioning/datasources.yaml /usr/share/grafana/conf/provisioning/datasources

EXPOSE 3000

#start grafana
CMD ["/usr/sbin/grafana-server", "--homepath=/usr/share/grafana"]