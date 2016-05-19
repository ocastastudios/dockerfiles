#! /bin/sh

# exit if a command fails
set -e

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
apt-get update
apt-get -y upgrade

# install s3 tools
apt-get -y install python python-pip mongodb-org-tools openssl curl
pip install awscli

# install go-cron
curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.7/go-cron-linux.gz | zcat > /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
apt-get autoremove


# cleanup
rm -rf /var/cache/apk/*
