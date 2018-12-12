#!/usr/bin/env bash

helm upgrade $RELEASE jupyterhub/jupyterhub --version=0.7.0 --values config.yaml