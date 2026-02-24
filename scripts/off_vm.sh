#!/bin/bash

cd ../terraform

echo "Desligando VM. . . "

terraform apply -var="status_da_vm=stopped" -auto-approve

echo "Instância desligada com sucesso!"