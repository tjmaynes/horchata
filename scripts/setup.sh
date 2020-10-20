SERVICE_USER=$1
ISTIO_CHART_VERSION=$2
ISTIO_NAMESPACE=$3
TILLER_NAMESPACE=$4

if [[ -z $SERVICE_USER ]]; then
  echo 'Please provide user to allow credentials.'
  exit 1
elif [[ -z $ISTIO_CHART_VERSION ]]; then
  echo 'Please specify a Helm Istio chart version to use.'
  exit 1
elif [[ -z $ISTIO_NAMESPACE ]]; then
  echo 'Please specify a namespace for Istio on Kubernetes.'
  exit 1
elif [[ -z $TILLER_NAMESPACE ]]; then
  echo 'Please specify a namespace for Tiller on Kubernetes.'
  exit 1
fi

setup_helm() {
  if [[ -z $(kubectl get clusterrolebinding | grep "cluster-admin") ]]; then
    kubectl create clusterrolebinding user-admin-binding \
      --clusterrole=cluster-admin \
      --user=$SERVICE_USER
  fi

  if [[ -z $(kubectl get serviceaccount --all-namespaces | grep "tiller") ]]; then
    kubectl create serviceaccount tiller --namespace kube-system
  fi

  if [[ -z $(kubectl get clusterrolebinding --all-namespaces | grep "tiller-admin-binding") ]]; then
    kubectl create clusterrolebinding tiller-admin-binding \
      --clusterrole=cluster-admin \
      --serviceaccount=kube-system:tiller
  fi

  if [[ -z $(kubectl get namespaces | grep "$TILLER_NAMESPACE") ]]; then
    kubectl create namespace $TILLER_NAMESPACE
  fi

  helm init \
    --service-account tiller \
    --tiller-namespace $TILLER_NAMESPACE \
    --upgrade
  helm repo update
}

setup_istio() {
  if [[ -x $(kubectl get namespaces | grep "$ISTIO_NAMESPACE") ]]; then
    kubectl create namespace $ISTIO_NAMESPACE
  fi

  helm repo add istio.io https://storage.googleapis.com/istio-release/releases/$ISTIO_CHART_VERSION/charts/

  helm fetch --untar --untardir charts 'istio.io/istio-init'

  helm template charts/istio-init \
    --name istio-init \
    --namespace $ISTIO_NAMESPACE \
    --set sidecarInjectorWebhook.enabled=false \
    --set grafana.enabled=true \
    --set servicegraph.enabled=true |
    kubectl apply -f -
}

main() {
  setup_helm
  setup_istio
}

main
