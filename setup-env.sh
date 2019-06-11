#!/bin/sh
export HOST_FQDN=$(kubectl get route knative-bg-deployment-demo --output jsonpath='{.status.domain}' -n knative-bg-deployment-domain)
echo $HOST_FQDN $KNATIVE_INGRESS