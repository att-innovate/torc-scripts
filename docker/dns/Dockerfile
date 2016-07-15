FROM phusion/baseimage:0.9.17

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq

# No need for ssh server
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install bind9
RUN apt-get -y install bind9

COPY provision/named.conf.options /etc/bind/named.conf.options
COPY provision/consul.conf /etc/bind/named/consul.conf
COPY provision/named.conf.local /etc/bind/named.conf.local
COPY provision/db.homer.ave /etc/bind/zones/db.homer.ave
COPY provision/db.10.250.3 /etc/bind/zones/db.10.250.3

# Install consul

RUN apt-get install wget unzip -y

RUN wget --no-check-certificate https://releases.hashicorp.com/consul/0.6.1/consul_0.6.1_linux_amd64.zip
RUN unzip consul_0.6.1_linux_amd64.zip; rm consul_0.6.1_linux_amd64.zip

RUN wget --no-check-certificate https://releases.hashicorp.com/consul/0.6.1/consul_0.6.1_web_ui.zip; \
    mkdir ui; unzip -d /ui consul_0.6.1_web_ui.zip; rm consul_0.6.1_web_ui.zip

COPY provision/consul.cfg /consul.cfg

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start bind9 and consul
COPY provision/startup.sh /startup.sh

ENTRYPOINT ["/startup.sh"]



