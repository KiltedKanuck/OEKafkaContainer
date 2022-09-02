FROM openedge:12.5.2

RUN apt-get -y update --fix-missing 
RUN apt-get -y install wget gnupg software-properties-common
RUN wget -qO - https://packages.confluent.io/deb/7.2/archive.key | apt-key add - 
RUN add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/7.2 stable main" 
RUN add-apt-repository "deb https://packages.confluent.io/clients/deb $(lsb_release -cs) main" 
RUN apt-get -y install librdkafka-dev

COPY ./getkafkaversion.sh /psc/wrk/
COPY ./consume.sh /psc/wrk/
COPY ./producer.sh /psc/wrk/
COPY ./code /psc/wrk/code

RUN chmod 'o+rwx' /psc/wrk/getkafkaversion.sh
RUN chmod 'o+rwx' /psc/wrk/producer.sh
RUN chmod 'o+rwx' /psc/wrk/consume.sh

LABEL maintainer="cameron.wright@progress.com"