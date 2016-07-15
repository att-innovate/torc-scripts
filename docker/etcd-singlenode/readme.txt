-- Docker build:
$ docker build -t etcd-singlenode .

-- Docker run:
Replace $MY_IP with the IP of your host running etcd

$ docker run -d --net=host torc-scheduler --master $MY_IP --config /config-minimal.yml


