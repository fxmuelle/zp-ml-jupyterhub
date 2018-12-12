#!/usr/bin/env bash

helm delete $RELEASE --purge
kubectl delete namespace $NAMESPACE
#gcloud container clusters delete $CLUSTERNAME --zone=$ZONE
