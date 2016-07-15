#!/bin/bash
if [ $# -eq 0 ] ; then
    echo "please pass in IP address of wedge, example: $ ./run_scheduler_master.sh 10.250.3.20"
    exit -1
fi

MY_IP=$1

docker run -d  --name torc-scheduler --net=host torc-scheduler --master $MY_IP --config /config.yml
