minikube start -p gitops --driver=docker --bootstrapper=kubeadm --kubernetes-version=latest --force

minikube profile gitops

minikube addons enable ingress

kubectl --namespace ingress-nginx wait \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s

export INGRESS_HOST=$(minikube ip)

