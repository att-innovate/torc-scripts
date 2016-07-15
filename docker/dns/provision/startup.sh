#!/bin/bash

service bind9 start
./consul agent -config-file=consul.cfg $1

