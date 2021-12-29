#!/bin/bash
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel
sudo yum install certbot -y
sudo export PUBLIC_IPV4_ADDRESS="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
sudo export PUBLIC_INSTANCE_NAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname)"
sudo certbot certonly --standalone --preferred-challenges http -d $PUBLIC_IPV4_ADDRESS.nip.io --dry-run
sudo certbot certonly --standalone --preferred-challenges http -d $PUBLIC_IPV4_ADDRESS.nip.io --staging
sudo mkdir -p /tmp/oauth2-proxy
sudo mkdir -p /opt/oauth2-proxy
sudo cd /tmp/oauth2-proxy
sudo curl -sfL https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.1.3/oauth2-proxy-v7.1.3.linux-amd64.tar.gz | tar -xzvf -
sudo mv oauth2-proxy-v7.1.3.linux-amd64/oauth2-proxy /opt/oauth2-proxy/
sudo export COOKIE_SECRET=$(python -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(16)).decode())')
sudo export GITHUB_USER=melashkr
sudo export GITHUB_CLIENT_ID=7a5a1bf85cf21e59b340
sudo export GITHUB_CLIENT_SECRET=b8ca8c6319d7fc8907cd6a2059e7dce07d1c0956
sudo export PUBLIC_URL=$(curl http://169.254.169.254/latest/meta-data/public-ipv4).nip.io
sudo /opt/oauth2-proxy/oauth2-proxy --github-user="${GITHUB_USER}"  --cookie-secret="${COOKIE_SECRET}" --client-id="${GITHUB_CLIENT_ID}" --client-secret="${GITHUB_CLIENT_SECRET}" --email-domain="*" --upstream=http://127.0.0.1:8080 --provider github --cookie-secure false --redirect-url=https://${PUBLIC_URL}/oauth2/callback --https-address=":443" --force-https --tls-cert-file=/etc/letsencrypt/live/$PUBLIC_URL/fullchain.pem --tls-key-file=/etc/letsencrypt/live/$PUBLIC_URL/privkey.pem

      
