#!/bin/bash
echo "------------ stop logging with ctrl-c --------------"

docker logs -f torc-scheduler
