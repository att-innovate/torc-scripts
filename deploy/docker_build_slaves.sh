#!/bin/bash

cd ~
DOCKER_DIR=$PWD/torc-scripts/docker

cd $DOCKER_DIR/rust-compiler-ubuntu
docker build -t cargo .

cd $DOCKER_DIR/influxdb
docker build -t influxdb .

cd $DOCKER_DIR/datacollector
scripts/build_it.sh
docker build -t datacollector .

docker pull attinnovate/charmander-pcp
