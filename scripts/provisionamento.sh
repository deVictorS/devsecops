echo "Iniciando provisionamento com Ansible. . ."

cd ../terraform
CHAVE="../projeto-devsecops.pem"
chmod 400 "$CHAVE"

IP_VM=$(terraform output -raw ip_publico | tr -d '\r\n')

ansible-playbook -i "$IP_VM," -u ubuntu --private-key "$CHAVE" \
    --ssh-common-args='-o StrictHostKeyChecking=no' \
    ../ansible/provisionamento.yaml

echo "Provisionamento concluído!"