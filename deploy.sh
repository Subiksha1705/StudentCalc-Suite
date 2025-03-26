#!/bin/bash

echo "Starting Deployment..."

# Ensure Minikube is running
echo "Checking Minikube status..."
minikube status >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Minikube is not running. Starting Minikube..."
  minikube start
fi

# Give executable permission to build script
chmod +x build.sh
./build.sh

# Docker Login
echo "Logging in to Docker..."
echo "s1705sha17" | docker login -u subiksha17 --password-stdin

# Build and Push Docker Image
docker tag studcalc subiksha17/studentcalculator
docker push subiksha17/studentcalculator

# Ensure Kubernetes uses Minikube's Docker daemon
eval $(minikube docker-env)

# Deploy to Kubernetes
kubectl delete deployment calc --ignore-not-found=true
kubectl create deployment calc --image=subiksha17/studentcalculator --port=80
kubectl expose deployment calc --type=NodePort --port=80

echo "Deployment successful!"
echo "To access your app, run: minikube service calc"
