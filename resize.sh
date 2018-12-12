#!/usr/bin/env bash

gcloud container clusters list
gcloud container node-pools list --cluster $CLUSTERNAME
gcloud container clusters resize $CLUSTERNAME --size $1