#!/bin/sh

echo "############ SERVING  - BLUE/GREEN DEPLOYMENT DEMO ##############"

kubectl create ns knative-bg-deployment-domain
kubectl apply -f configuration.yml