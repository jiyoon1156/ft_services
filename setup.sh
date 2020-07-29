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
docker build -t nginx_img ./nginx/
# docker build -t service_test ./srcs/test
docker build -t ftps_img ./ftps --build-arg IP=${IP}
docker build -t mysql_img ./mysql/ --build-arg IP=${IP}
docker build -t wp_img ./wordpress --build-arg IP=${IP}
docker build -t pma_img ./phpmyadmin --build-arg IP=${IP}
docker build -t influxdb_img ./influxdb
docker build -t telegraf_img ./telegraf
docker build -t grafana_img ./grafana

#metallb

kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml
kubectl apply -f config.yaml

echo "Creating pods and services..."
kubectl create -f nginx.yaml
kubectl create -f mysql.yaml
kubectl create -f phpmyadmin.yaml
kubectl create -f wordpress.yaml
kubectl create -f influxdb.yaml
kubectl create -f telegraf.yaml
kubectl create -f grafana.yaml
kubectl create -f ftps.yaml

# echo "Opening the network in your browser"
# open http://$IP
minikube service list
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"