#!/bin/sh

# This script setup minikube, builds Docker images, and create pods

export MINIKUBE_HOME=/Users/jhur/goinfre/
echo "Starting minikube..."
minikube --vm-driver=virtualbox start --extra-config=apiserver.service-node-port-range=1-35000
# minikube --vm-driver=docker start --extra-config=apiserver.service-node-port-range=1-35000
echo "Enabling addons..."
# minikube addons enable ingress
minikube addons enable dashboard
echo "Launching dashboard..."
minikube dashboard &

echo "Eval..."
eval $(minikube docker-env)

# IP=$(minikube ip)
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"

echo "Building images..."
docker build -t nginx_img ./nginx/
# docker build -t service_test ./srcs/test
# docker build -t service_ftps --build-arg IP=${IP} ./srcs/ftps
# docker build -t service_mysql ./srcs/mysql --build-arg IP=${IP}
# docker build -t service_wordpress ./srcs/wordpress --build-arg IP=${IP}
# docker build -t service_phpmyadmin ./srcs/phpmyadmin --build-arg IP=${IP}
# docker build -t service_influxdb ./srcs/influxdb
# docker build -t service_grafana ./srcs/grafana

#metallb
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml

kubectl apply -f config.yaml
echo "Creating pods and services..."
kubectl create -f nginx.yaml

# echo "Opening the network in your browser"
# open http://$IP
minikube service list