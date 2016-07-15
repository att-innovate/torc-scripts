Example command to run mesos on Facebook Wedge. Replace IP address with actual address.


-- Facebook Wedge 1 running ONL

Mesos Master
$ docker run -d --name mesos-master --net=host --memory=1g -e MY_IP=10.250.1.111 mesos master

Mesos Slave
$ docker run -d  --name mesos-slave --net=host  -e MY_IP=10.250.1.111 \
        -e MACHINE_NAME="wedge-fb-1" -e MACHINE_TYPE="master"  -e MACHINE_FUNCTION="controller" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /sys/fs/cgroup/:/sys/fs/cgroup/ \
        mesos slave --master=zk://10.250.1.111:2181/mesos


-- Facebook Wedge 1 running Centos

Mesos Master
$ docker run -d --name mesos-master --net=host --memory=1g -e MY_IP=10.250.1.111 mesos master

Mesos Slave
$ docker run -d  --name mesos-slave --net=host  -e MY_IP=10.250.1.111  -e CGROUP=/cgroup  \
		-e MACHINE_NAME="wedge-fb-1"  -e MACHINE_TYPE="master" -e MACHINE_FUNCTION="controller" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /cgroup/:/cgroup/ \
		mesos slave --master=zk://10.250.1.111:2181/mesos


-- Facebook Wedge 2 running Centos

Mesos Master
$ docker run -d --name mesos-master --net=host --memory=1g -e MY_IP=10.16.0.33 mesos master

Mesos Slave
$ docker run -d  --name mesos-slave --net=host  -e MY_IP=10.16.0.33  -e CGROUP=/cgroup  \
		-e MACHINE_NAME="wedge-fb-2"  -e MACHINE_TYPE="master" -e MACHINE_FUNCTION="controller" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /cgroup/:/cgroup/ \
		mesos slave --master=zk://10.16.0.33:2181/mesos
