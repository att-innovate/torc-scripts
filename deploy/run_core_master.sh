#!/bin/bash
if [ $# -eq 0 ] ; then
    echo "please pass in IP address of wedge, example: $ ./run_core_master.sh 10.250.3.20"
    exit -1
fi

MY_IP=$1
DIR=$PWD

docker run -d --name etcd --net=host -e MY_IP=$MY_IP etcd-singlenode

docker run -d --name mesos-master --net=host --memory=1g -e MY_IP=$MY_IP mesos master

docker run -d  --name mesos-slave --net=host  -e MY_IP=$MY_IP \
        -e MACHINE_NAME="wedge" -e MACHINE_TYPE="master" -e MACHINE_FUNCTION="controller" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /sys/fs/cgroup/:/sys/fs/cgroup/ \
        mesos slave --master=zk://$MY_IP:2181/mesos
