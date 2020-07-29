#!/bin/sh

# This script setup minikube, builds Docker images, and create pods
export MINIKUBE_HOME=/Users/jhur/goinfre/
echo "Starting minikube..."
minikube --vm-driver=virtualbox start --extra-config=apiserver.service-node-port-range=1-35000

echo "Eval..."
eval $(minikube docker-env)

echo "Enabling addons..."
minikube addons enable metrics-server
minikube addons enable dashboard

echo "Launching dashboard..."
minikube dashboard &

# IP=$(minikube ip)
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"

echo "Building images..."
docker build -t nginx_img ./srcs/nginx
docker build -t ftps_img ./srcs/ftps --build-arg IP=${IP}
docker build -t mysql_img ./srcs/mysql --build-arg IP=${IP}
docker build -t wp_img ./srcs/wordpress --build-arg IP=${IP}
docker build -t pma_img ./srcs/phpmyadmin --build-arg IP=${IP}
docker build -t influxdb_img ./srcs/influxdb
docker build -t telegraf_img ./srcs/telegraf
docker build -t grafana_img ./srcs/grafana

#metallb
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml
kubectl apply -f ./srcs/metalLB_config.yaml

echo "Creating pods and services..."
kubectl create -f ./srcs/nginx.yaml
kubectl create -f ./srcs/mysql.yaml
kubectl create -f ./srcs/phpmyadmin.yaml
kubectl create -f ./srcs/wordpress.yaml
kubectl create -f ./srcs/influxdb.yaml
kubectl create -f ./srcs/telegraf.yaml
kubectl create -f ./srcs/grafana.yaml
kubectl create -f ./srcs/ftps.yaml

# echo "Opening the network in your browser"
# open http://$IP
minikube service list
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"