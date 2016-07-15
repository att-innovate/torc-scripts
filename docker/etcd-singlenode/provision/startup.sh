#!/bin/bash

export MY_IP=${MY_IP}
echo -e  "Starting etcd on $MY_IP"

export ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
export ETCD_ADVERTISE_CLIENT_URLS=http://$MY_IP:2379

cd /etcd
./etcd &

cd /app
export ETCD_HOST=$MY_IP
export ETCD_PORT=2379

nodejs server.js