#!/bin/bash

echo "Starting Deployment..."
chmod +x build.sh
./build.sh

# Docker Login
echo "s1705sha17" | docker login -u subiksha17 --password-stdin
docker tag studcalc subiksha17/studentcalculator
docker push subiksha17/studentcalculator


# Deploy to Kubernetes
kubectl create deployment calc --image=subiksha17/studentcalculator --port 80
kubectl expose deployment calc --type=NodePort --port=80

echo "Deployment successful! Access your app via Minikube service."
