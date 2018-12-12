#!/usr/bin/env bash

curl https://sdk.cloud.google.com | bash
gcloud init
gcloud components install kubectl
gcloud config set compute/zone $ZONE
gcloud beta container clusters create $CLUSTERNAME \
   --machine-type n1-standard-2 \
   --num-nodes 1 \
   --cluster-version latest \
   --node-labels hub.jupyter.org/node-purpose=core
kubectl get node
