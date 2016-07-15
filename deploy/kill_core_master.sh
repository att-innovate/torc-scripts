#!/bin/bash

docker kill mesos-slave
docker rm mesos-slave

docker kill mesos-master
docker rm mesos-master

docker kill etcd
docker rm etcd
