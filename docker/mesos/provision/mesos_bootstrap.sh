#!/bin/bash

# set font types
bold="\e[1;36m"
normal="\e[0m"


export MY_IP=${MY_IP}
echo -e  "${bold}==> Starting Mesos Bootstrap on $MY_IP ${normal}"

export MACHINE_NAME=${MACHINE_NAME:=$MY_IP}
echo -e  "${bold}==> With Machine Name $MACHINE_NAME ${normal}"

export MACHINE_TYPE=${MACHINE_TYPE:=Default}
echo -e  "${bold}==> With Machine Type $MACHINE_TYPE ${normal}"

export MACHINE_FUNCTION=${MACHINE_FUNCTION:=Default}
echo -e  "${bold}==> With Machine Function $MACHINE_FUNCTION ${normal}"

# configure Mesos
export MASTER_PORT=${MASTER_PORT:-5050}
export SLAVE_PORT=${SLAVE_PORT:-5051}


# Set locale: this is required by the standard Mesos startup scripts
echo -e  "${normal}==> info: Setting locale to en_US.UTF-8..."
locale-gen en_US.UTF-8


function start_zookeeper {
    echo -e  "${normal}==> info: Starting Zookeeper..."
    service zookeeper start
}

function start_slave {

    MASTER=`echo $1 | cut -d '=' -f2`

    # set the arguments for mesos slave
    echo ${MASTER} > /etc/mesos/zk
    echo ${MY_IP} > /etc/mesos-slave/ip
    echo $MY_IP > /etc/mesos-slave/hostname
    echo host:${MY_IP} > /etc/mesos-slave/attributes
    echo machine-name:${MACHINE_NAME} >> /etc/mesos-slave/attributes
    echo machine-type:${MACHINE_TYPE} >> /etc/mesos-slave/attributes
    echo machine-function:${MACHINE_FUNCTION} >> /etc/mesos-slave/attributes
    echo /var/lib/mesos > /etc/mesos-slave/work_dir
    echo docker > /etc/mesos-slave/containerizers
    echo 10mins > /etc/mesos-slave/executor_registration_timeout

    echo -e  "${bold}==> info: Mesos slave will try to register with a master at ${MASTER}"
    echo -e  "${normal}==> info: Starting slave..."

    # start slave 
    /usr/bin/mesos-init-wrapper.sh slave &

	# wait for the slave to start
    sleep 1 && while [[ -z $(netstat -lnt | awk "\$6 == \"LISTEN\" && \$4 ~ \".$SLAVE_PORT\" && \$1 ~ tcp") ]] ; do
	    echo -e  "${normal}==> info: Waiting for Mesos slave to come online..."
	    sleep 3;
	done
	echo -e  "${normal}==> info: Mesos slave started on port ${SLAVE_PORT}"
}


function start_master {

    # set the arguments for mesos master
    echo $MY_IP > /etc/mesos-master/ip
    echo $MY_IP > /etc/mesos-master/hostname
    echo "zk://localhost:2181/mesos" > /etc/mesos/zk
    echo in_memory > /etc/mesos/registry
    echo /var/lib/mesos > /etc/mesos-slave/work_dir
    echo torc > /etc/mesos-master/cluster
    echo 1 > /etc/mesos-master/quorum
    
    # start master 
    echo -e  "${normal}==> info: Starting Mesos master..."
    /usr/bin/mesos-init-wrapper.sh master &

	# wait for the master to start
    sleep 1 && while [[ -z $(netstat -lnt | awk "\$6 == \"LISTEN\" && \$4 ~ \".$MASTER_PORT\" && \$1 ~ tcp") ]] ; do
	    echo -e  "${normal}==> info: Waiting for Mesos master to come online..."
	    sleep 3;
	done
	echo -e  "${normal}==> info: Mesos master started on port ${MASTER_PORT}"

}

function print_help {

    echo -e  "${normal}==> help ..."

}

# Catch the command line options.
case "$1" in
    master)
        start_zookeeper && start_master;;
    slave)
        start_slave $2;;
    *)
        print_help
esac

wait

