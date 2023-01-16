#!/bin/bash

yc_result=`yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/otus-devops/.ssh/appuser.pub`

if [ $? -eq 0 ]; then
    echo OK
else
    exit 1
fi

dynamic_host=`echo $yc_result | awk '/one_to_one_nat/ {sub(/.*address: /,"",$0); print $1}' | tr -d ' '`
dynamic_host="$dynamic_host"

echo "--------------------------------------"
echo "                                      "
echo "[создан новый инстанс по адресу:$dynamic_host]"
echo "                                      "
echo "--------------------------------------"

cat install_ruby.sh install_mongodb.sh deploy.sh | ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null yc-user@$dynamic_host 'bash -'

if [ $? -eq 0 ]; then
	echo "🙃 Enjoy! $dynamic_host:9292"
else
    exit 1
fi
