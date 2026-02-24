#!/bin/bash

cd ../terraform
CHAVE="../projeto-devsecops.pem"

echo "Ligando servidor e limpando cache de IP. . ."
terraform apply -var="status_da_vm=running" -auto-approve

echo "Sincronizando novo IP com a AWS. . ."
terraform refresh -var="status_da_vm=running"

IP_VM=$(terraform output -raw ip_publico | tr -d '\r\n')

while [ -z "$IP_VM" ] || [ "$IP_VM" == "null" ] || [ "$IP_VM" == "" ]; do
    echo "IP novo ainda não disponível... tentando novamente"
    sleep 3
    terraform refresh -var="status_da_vm=runnin" > /dev/null
    IP_VM=$(terraform output ip_publico | sed 's/.*= *//;s/"//g;s/ //g' | tr -d '\r\n')
done 

echo "Novo IP detectado: $IP_VM"

echo "Atualizando inventário do Ansible. . ."
cat <<EOF > ../ansible/inventory.ini
[servidor]
vm-devsecops ansible_host=$IP_VM ansible_user=ubuntu ansible_ssh_private_key_file=$CHAVE
EOF

echo "Aguardando o servidor aceitar conexões. . ."

echo "DEBUG: Acesso (keys): "$CHAVE""
echo "DEBUG: Testando IP: [$IP_VM]"
echo "DEBUG: Comando: ssh -i "$CHAVE" ubuntu@$IP_VM"

until ssh -i "$CHAVE" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ConnectTimeout=2 \
    -o IdentitiesOnly=yes \
    ubuntu@$IP_VM "exit" > /dev/null 2>&1
do
    echo "SSH ainda recusando... tentando em 5"
    sleep 5
done

echo "Conectado com sucesso!"

ssh -i "$CHAVE" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o IdentitiesOnly=yes \
    ubuntu@$IP_VM

echo ""
read -p "Desligar a VM agora? (s/n): " -n 1 RESPOSTA
echo ""

if [[ "$RESPOSTA" =~ ^[Ss]$ ]]; then
    echo "Desligando a instância. . ."
    terraform apply -var="status_da_vm=stopped" -auto-approve
else
    echo "VM mantida em execução!"
fi
