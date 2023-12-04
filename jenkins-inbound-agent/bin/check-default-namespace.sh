#!/bin/bash

## Check if the kubernetes manifest have explicitly set default namespace
if [ "$#" -eq 0 ]
then
  echo "Path to Kubernetes yaml manifests is required"
  exit 1
else
    cat $1 | grep -E '^kind:|^\s{2}name:|^\s{2}namespace:\s{0,}"{0,1}default"{0,1}\s{0,}$' | grep -E 'namespace:' -B2
fi
