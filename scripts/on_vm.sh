#!/bin/bash

cd ../infra/main.tf

echo "Ligando servidor e limpando cache de IP. . ."
terraform apply -var="status_da_vm+running" -auto-approve