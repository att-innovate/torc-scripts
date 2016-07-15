#!/bin/bash
SCHEDULER_DIR=/root/torc_scheduler
DOCKER_DIR=/root/torc-scripts/docker/torc-scheduler

if [ -d $SCHEDULER_DIR ]
then
    cd $SCHEDULER_DIR
    git pull
else
    cd /root
    git clone https://github.com/att-innovate/torc_scheduler.git
fi

docker run -v $SCHEDULER_DIR:/project/ cargo build

rm $DOCKER_DIR/provision/torc_scheduler
cp $SCHEDULER_DIR/target/debug/torc_scheduler $DOCKER_DIR/provision/

cd $DOCKER_DIR
docker build -t torc-scheduler .

