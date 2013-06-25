#!/usr/bin/env bash

apt-get update
echo "127.0.0.1 salt salt-master" >> /etc/hosts

echo "salt-master" >> /etc/hostname
hostname salt-master

wget -O - http://bootstrap.saltstack.org | sudo sh
apt-get install -y git salt-master python-pip

# We want to pre-authorize the minion on the master
salt-key --gen-keys=salt-master
cp salt-master.pub /etc/salt/pki/minion/minion.pub
cp salt-master.pem /etc/salt/pki/minion/minion.pem
cp salt-master.pub /etc/salt/pki/master/minions/salt-master

sed -ie 's/#id:/id: salt-master/' /etc/salt/minion

service salt-minion restart

#pip install salt-api

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:dotcloud/lxc-docker
sudo apt-get update
sudo apt-get install -y lxc-docker

cd /vagrant/docker-py
pip -r requirements.txt
python setup.py install

ln -sf /vagrant/roots/salt /srv/salt
ln -sf /vagrant/roots/pillar /srv/pillar

docker pull ubuntu