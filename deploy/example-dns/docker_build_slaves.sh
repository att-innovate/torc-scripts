#!/bin/bash

for SLAVE_NODE in $(cat ./slaves.txt)
do
    ssh -t bladerunner@${SLAVE_NODE} "sudo ~/torc-scripts/deploy/example-dns/onnode/docker_build_slave.sh"
done
