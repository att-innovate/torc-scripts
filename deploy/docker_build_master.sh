#!/bin/bash
DIR=$PWD

DOCKER_DIR=/root/torc-scripts/docker

cd $DOCKER_DIR/rust-compiler-ubuntu
docker build -t cargo .

cd $DOCKER_DIR/mesos
docker build -t mesos .

cd $DOCKER_DIR/etcd-singlenode
docker build -t etcd-singlenode .

cd $DOCKER_DIR/dns
docker build -t dns .

cd $DOCKER_DIR/vector
docker build -t vector .

docker pull attinnovate/charmander-pcp

# compile and build stateync
STATESYNC_DIR=/root/torc_statesync

if [ -d $STATESYNC_DIR ]
then
    cd $STATESYNC_DIR
    git pull
else
    cd /root
    git clone https://github.com/att-innovate/torc_statesync.git
fi

docker run -v $STATESYNC_DIR:/project/ cargo build

cd $DOCKER_DIR/statesync
rm ./provision/statesync
cp $STATESYNC_DIR/target/debug/statesync ./provision/

docker build -t statesync .
