# base image
FROM ubuntu:16.04

# MAINTAINER
MAINTAINER liuyangfa@juzix.net

ENV DEBIAN_FRONTEND noninteractive

# update package info and install wget vim 
RUN apt-get update && apt-get install -y wget vim apt-utils software-properties-common supervisor && add-apt-repository -y -s -u ppa:yyl123456/platon-mpc-vm && apt-get install platon-without-mpc -y && mkdir /opt/node/data/platon -p 

COPY changeinfo.sh platon.json /opt/node/
#COPY platon.json /opt/node/

RUN chmod +x /opt/node/changeinfo.sh

EXPOSE 6789 16789

CMD /opt/node/changeinfo.sh && tail -f /tmp/node.log || tail -f /var/log/syslog
#CMD ["bash"]

