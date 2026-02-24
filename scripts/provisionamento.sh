echo "Iniciando provisionamento com Ansible. . ."

cd ../terraform
CHAVE="../projeto-devsecops.pem"

IP_VM=$(terraform output -raw ip_pubico | tr -d '\r\n')

ansible-playbook -i "$IP_VM," -u ubuntu --private-key CHAVE \
    --ssh-common-args='-o StrictHostKeyChecking=no' \
    ../ansible/playbook.yml

echo "Provisionamento concluído!"