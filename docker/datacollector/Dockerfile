FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

ADD charmander-datacollector /usr/bin/charmander-datacollector
RUN chmod +x /usr/bin/charmander-datacollector

ENTRYPOINT ["/usr/bin/charmander-datacollector", "-stderrthreshold=INFO", "-influxdb_host=influxdb.service.torc:8086", "-source_torc_host=torc-scheduler.service.torc:3000"]

