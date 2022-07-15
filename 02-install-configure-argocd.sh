# Installing and Configuring ArgoCD

VERSION=$(curl --silent \
    "https://api.github.com/repos/argoproj/argo-cd/releases/latest" \
    | grep '"tag_name"' \
    | sed -E 's/.*"([^"]+)".*/\1/')

# /usr/local/bin/argocd should not exist 
sudo rm -rf /usr/local/bin/argocd
sudo curl -sSL -o /usr/local/bin/argocd \
    https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64

sudo chmod +x /usr/local/bin/argocd

kubectl create namespace argocd

helm repo add argo \
    https://argoproj.github.io/argo-helm


export INGRESS_HOST=$(minikube ip)
echo "INGRESS_HOST:"
echo $INGRESS_HOST

helm upgrade --install \
   argocd argo/argo-cd \
   --namespace argocd \
   --set server.ingress.hosts="{argocd.$INGRESS_HOST.nip.io}" \
   --values  argocd-values.yaml \
   --wait


export PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

argocd login \
    --insecure \
    --username admin \
    --password $PASS \
    --grpc-web \
    argocd.$INGRESS_HOST.nip.io       