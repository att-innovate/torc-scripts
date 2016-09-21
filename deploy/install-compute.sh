#!/bin/bash
# run with sudo
if [ $(id -u) -ne 0 ] ; then echo "Please run as root" ; exit 1 ; fi
if [ $# -ne 3 ] ; then echo "Missing arguments - example: sudo ./install-compute.sh {wedge_ip} {machine_name} {machine_function}" ; exit 1 ; fi

MESOS_MASTER_IP=$1
MACHINE_NAME=$2
MACHINE_FUNCTION=$3
MACHINE_TYPE=slave

apt-get update
apt-get upgrade -y

DOCKER_PACKAGE_VERSION=1.9.1-0~trusty
MESOS_PACKAGE_VERSION=0.28.0-2.0.16.ubuntu1404
GO_PACKAGE_VERSION=1.4.2

MY_IP=`ifconfig | sed -En 's/127.0.0.1//;s/172.17//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`

# to support docker/mesos packages
apt-get install -y apt-transport-https ca-certificates wget

# add some additional package repositories/keys
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF; DISTRO=$(lsb_release -is | tr "[:upper:]" "[:lower:]"); CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
echo deb http://download.virtualbox.org/virtualbox/debian trusty contrib > /etc/apt/sources.list.d/virtualbox.list
apt-get update

# install docker
if [ ! -f /usr/bin/docker ]
then
    apt-get install -y linux-image-extra-$(uname -r) aufs-tools
    apt-get install -y docker-engine=$DOCKER_PACKAGE_VERSION
    
    # needed for --ipc=host setting for Docker, used by pcp
    echo none /dev/mqueue mqueue defaults 0 0 >> /etc/fstab

    # set Calico/Docker config
    echo "DOCKER_OPTS=--cluster-store=etcd://etcd.service.torc:2379" > /etc/default/docker
fi


# Install gcc
apt-get -y install git wget libtool build-essential pkg-config autoconf

# Install ntp
apt-get -y install ntp

# Install network tools
apt-get -y install bridge-utils ipset

# Install perf tool
apt-get -y install linux-tools-common linux-tools-generic linux-tools-`uname -r`

# Install Top Tools
apt-get -y install iftop htop

# Install go
if [ ! -d /usr/local/go ]
then
  wget --progress=bar:force https://storage.googleapis.com/golang/go${GO_PACKAGE_VERSION}.linux-amd64.tar.gz
  tar -C /usr/local -xzf go${GO_PACKAGE_VERSION}.linux-amd64.tar.gz; rm go${GO_PACKAGE_VERSION}.linux-amd64.tar.gz
  chmod -R o+w /usr/local/go
fi


# install Mesos
apt-get -y install mesos=${MESOS_PACKAGE_VERSION}

# change hostname to nodename
sed -i 's/.*/'${MACHINE_NAME}'/' /etc/hostname

# set Mesos attributes
if [ ! -f /etc/mesos-slave/containerizers ]
then
  rm /etc/init/mesos-master.conf; rm /etc/init/zookeeper.conf
  mkdir -p /etc/mesos-slave
  echo docker,mesos > /etc/mesos-slave/containerizers
  echo $MY_IP > /etc/mesos-slave/ip
  echo $MY_IP > /etc/mesos-slave/hostname
  echo host:${MY_IP} > /etc/mesos-slave/attributes
  echo machine-name:${MACHINE_NAME} >> /etc/mesos-slave/attributes
  echo machine-type:${MACHINE_TYPE} >> /etc/mesos-slave/attributes
  echo machine-function:${MACHINE_FUNCTION} >> /etc/mesos-slave/attributes
  echo 10mins > /etc/mesos-slave/executor_registration_timeout
  echo zk://${MESOS_MASTER_IP}:2181/mesos > /etc/mesos/zk
  echo /var/lib/mesos > /etc/mesos-slave/work_dir
fi

# check out torc-scripts
if [ ! -d ~/torc-scripts ]
then
    cd ~
    git clone https://github.com/att-innovate/torc-scripts.git    
fi

# install calicoctl
if [ ! -f ~/calicoctl ]
then
    cd ~
    wget http://www.projectcalico.org/builds/calicoctl
    chmod +x calicoctl
    
    docker pull calico/node:latest
    docker pull calico/node-libnetwork:latest
fi

# do some cleanup
apt-get -y autoremove


echo '----Reboot Machine !-----'
