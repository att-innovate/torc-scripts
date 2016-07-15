#!/bin/bash

cd ~

SCHEDULER_DIR=$PWD/torc_dns_scheduler
CONTAINER_DIR=$PWD/torc-scripts/docker/example-dns/torc-dns-scheduler

if [ -d $SCHEDULER_DIR ]
then
    cd $SCHEDULER_DIR
    git pull
else
    git clone https://github.com/att-innovate/torc_dns_scheduler.git
fi

docker run -v $SCHEDULER_DIR:/project/ cargo build

rm $CONTAINER_DIR/provision/torc_dns_scheduler
cp $SCHEDULER_DIR/target/debug/torc_dns_scheduler $CONTAINER_DIR/provision/

cd $CONTAINER_DIR
docker build -t torc-dns-scheduler .
