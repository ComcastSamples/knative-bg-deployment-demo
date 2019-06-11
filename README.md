# knative-bg-deployment-demo


## Get ENV for node/cluster

    kubectl get node --namespace istio-system  --output 'jsonpath={.items[0].status.addresses[0].address}'

    kubectl get svc knative-ingressgateway --namespace istio-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}'

    export HOST_IP=$(kubectl get node --namespace istio-system  --output 'jsonpath={.items[0].status.addresses[0].address}')

    export HOST_PORT=$(kubectl get svc knative-ingressgateway --namespace istio-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

    export KNATIVE_INGRESS=$HOST_IP:$HOST_PORT


## Deployment

    kubectl create ns knative-bg-deployment-domain

    kubectl apply  -f configuration.yml

    kubectl apply  -f v1-100pct-route.yml

    kubectl apply  -f v1-v2-50pct-route.yml


## Watch progress in another window

    watch -n 1 -t kubectl get pod,deploy,svc,serving -n knative-bg-deployment-domain


## Get ENV for curl

    kubectl get route knative-bg-deployment-demo --output=custom-columns=NAME:.metadata.name,DOMAIN:.status.domain -n knative-bg-deployment-domain

    kubectl get route knative-bg-deployment-demo --output jsonpath='{.status.domain}' -n knative-bg-deployment-domain

    kubectl get route knative-bg-deployment-demo --output go-template --template='{{.status.domain}}{{"\n"}}' -n knative-bg-deployment-domain

    export HOST_FQDN=$(kubectl get route knative-bg-deployment-demo --output jsonpath='{.status.domain}' -n knative-bg-deployment-domain)

    echo $HOST_FQDN $KNATIVE_INGRESS

## Verify

    curl -H "Host: $HOST_FQDN" http://$KNATIVE_INGRESS/ -w "\n"

    for i in {1..10} ; do curl -H "Host: $HOST_FQDN" http://$KNATIVE_INGRESS/ -w "\n" ; done;


    kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'


    export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')

    curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/

    echo Name of the Pod: $POD_NAME

    kail -d knative-bg-deployment-demo -n knative-bg-deployment-domain -c user-container



Based on the official Knative documentation, licensed under the Creative Commons Attribution 4.0 License,
and code samples are licensed under the Apache 2.0 License
