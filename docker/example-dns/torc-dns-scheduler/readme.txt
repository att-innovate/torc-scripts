# To run it replace $MY_IP with the public IP of your wedge and the correct config file.
# Config file has to be part of the deployment.

$ docker run -d --net=host torc-dns-scheduler --master $MY_IP --config /config.yml
