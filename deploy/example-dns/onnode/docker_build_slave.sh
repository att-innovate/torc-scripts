#!/bin/bash

cd ~
DOCKER_DIR=$PWD/torc-scripts/docker/example-dns

cd $DOCKER_DIR/bind9
docker build -t bind9 .

cd $DOCKER_DIR/normalload
./scripts/build_it.sh
docker build -t normalload .

cd $DOCKER_DIR/smartscaling
docker build -t smartscaling .
