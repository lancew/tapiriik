#!/usr/bin/env bash

# Install system requirements

# mongodb multipolygon geojson support needs at least mongodb 2.6. trusty has 2.4 by default
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list


sudo apt-get update
sudo apt-get install -y python3-pip libxml2-dev libxslt-dev zlib1g-dev git redis-server rabbitmq-server mongodb-org

sudo systemctl enable mongod
sudo systemctl start mongod


# Fix pip
pip3 install --upgrade pip

# Install app requirements
pip3 install --upgrade -r /vagrant/requirements.txt

# Fix the default python instance
update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2

# Put in a default local_settings.py (if one doesn't exist)
if [ ! -f /vagrant/tapiriik/local_settings.py ]; then
    cp /vagrant/tapiriik/local_settings.py.example /vagrant/tapiriik/local_settings.py
    # Generate credential storage keys
    python /vagrant/credentialstore_keygen.py >> /vagrant/tapiriik/local_settings.py
fi


