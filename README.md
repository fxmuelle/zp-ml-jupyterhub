
## Setup Kubernetes on Google Cloud
https://z2jh.jupyter.org/en/stable/google/step-zero-gcp.html

### Install google cloud sdk
THe following only has to be done once:

From https://cloud.google.com/sdk/downloads:
``` 
curl https://sdk.cloud.google.com | bash
gcloud init
```
account: fxmuelle@gmail.com
project: zp-workshop-ml-jupyterhub`

Activating Kubernetes Engine API:
https://console.cloud.google.com/apis/api/container.googleapis.com/overview?project=zp-workshop-ml-jupyterhub

### Install kubectl plugin
```
gcloud components install kubectl
```

### Set zone

```
ZONE=europe-west1-b
gcloud config set compute/zone $ZONE
```

### Create cluster
```
## Enter a name for your cluster
CLUSTERNAME=cl-jhub
 
gcloud beta container clusters create $CLUSTERNAME \
   --machine-type n1-standard-2 \
   --num-nodes 2 \
   --cluster-version latest \
   --node-labels hub.jupyter.org/node-purpose=core
```
Check running nodes:
```
kubectl get node
```

### Account permissions
```
# Enter your email
EMAIL=fxmuelle@gmail.com

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$EMAIL
```  

### Install helm (package manager for k8s)
https://zero-to-jupyterhub-with-kubernetes.readthedocs.io/en/latest/setup-helm.html

```  
brew install kubernetes-helm
kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
```  

### Setup JupyterHub config
https://z2jh.jupyter.org/en/stable/setup-jupyterhub.html#setup-jupyterhub

✔ ~/Projects/Zielpuls/WorkshopML/jupyterhub-on-gcloud 
16:32 $ openssl rand -hex 32
<token>

- Create config.yml:
```
proxy:
  secretToken: "<token>"
```

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
16:54 $ helm init --upgrade
$HELM_HOME has been configured at /Users/fmu/.helm.

Tiller (the Helm server-side component) has been upgraded to the current version.
Happy Helming!
✔ ~/Projects/Zielpuls/WorkshopML/jupyterhub-on-gcloud 
16:54 $ helm init --upgrade --service-account tiller
$HELM_HOME has been configured at /Users/fmu/.helm.

Tiller (the Helm server-side component) has been upgraded to the current version.
Happy Helming!
✔ ~/Projects/Zielpuls/WorkshopML/jupyterhub-on-gcloud 
16:54 $ RELEASE=jhub
✔ ~/Projects/Zielpuls/WorkshopML/jupyterhub-on-gcloud 
16:54 $ NAMESPACE=jhub
✔ ~/Projects/Zielpuls/WorkshopML/jupyterhub-on-gcloud 
16:54 $ 
✔ ~/Projects/Zielpuls/WorkshopML/jupyterhub-on-gcloud 
16:54 $ helm upgrade --install $RELEASE jupyterhub/jupyterhub \
>   --namespace $NAMESPACE  \
>   --version 0.7.0 \
>   --values config.yaml
Release "jhub" does not exist. Installing it now.
NAME:   jhub
LAST DEPLOYED: Sun Sep 23 16:54:52 2018
NAMESPACE: jhub
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME          TYPE          CLUSTER-IP     EXTERNAL-IP  PORT(S)       AGE
hub           ClusterIP     10.31.247.143  <none>       8081/TCP      1s
proxy-api     ClusterIP     10.31.241.47   <none>       8001/TCP      1s
proxy-public  LoadBalancer  10.31.252.11   <pending>    80:32555/TCP  1s

==> v1/Pod(related)
NAME                   READY  STATUS             RESTARTS  AGE
hub-5d887c57f-gjhbn    0/1    Pending            0         1s
proxy-c7d48bb79-b6ttz  0/1    ContainerCreating  0         1s

==> v1/Secret
NAME        TYPE    DATA  AGE
hub-secret  Opaque  1     1s

==> v1/ConfigMap
NAME        DATA  AGE
hub-config  36    1s

==> v1beta1/Role
NAME  AGE
hub   1s

==> v1beta1/RoleBinding
NAME  AGE
hub   1s

==> v1beta2/Deployment
NAME   DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
hub    1        1        1           0          1s
proxy  1        1        1           0          1s

==> v1beta1/PodDisruptionBudget
NAME   MIN AVAILABLE  MAX UNAVAILABLE  ALLOWED DISRUPTIONS  AGE
hub    1              N/A              0                    1s
proxy  1              N/A              0                    1s

==> v1/PersistentVolumeClaim
NAME        STATUS   VOLUME    CAPACITY  ACCESS MODES  STORAGECLASS  AGE
hub-db-dir  Pending  standard  1s

==> v1/ServiceAccount
NAME  SECRETS  AGE
hub   1        1s


NOTES:
Thank you for installing JupyterHub!

Your release is named jhub and installed into the namespace jhub.

You can find if the hub and proxy is ready by doing:

 kubectl --namespace=jhub get pod

and watching for both those pods to be in status 'Ready'.

You can find the public IP of the JupyterHub by doing:

 kubectl --namespace=jhub get svc proxy-public

It might take a few minutes for it to appear!

Note that this is still an alpha release! If you have questions, feel free to
  1. Read the guide at https://z2jh.jupyter.org
  2. Chat with us at https://gitter.im/jupyterhub/jupyterhub
  3. File issues at https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues
  
  

