FROM openjdk:8
#FROM ubuntu:16.04
MAINTAINER Marcin Kasiñski <marcin.kasinski@gmail.com> 


#ZOOKEEPER_CONNECT=x.x.x.x:2181,x.x.x.x:2181,x.x.x.x:2181
#BROKER_NODES="1=x.x.x.x;2=x.x.x.x"

ENV KAFKA_MIRROR=http://ftp.man.poznan.pl/apache/kafka/1.1.0/ \
	KAFKA_VERSION=kafka_2.12-2.0.0 \
	ZOOKEEPER_CONNECT="mainserver:2181" \
	BROKER_NODES="1=mainserver.sdssd.sdsd.d;2=mainserver2" \
	CONFIG="/opt/kafka/config/server.properties"

RUN mkdir /usr/src/myapp

ADD libs.sh /usr/src/myapp/libs.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/libs.sh
ADD start.sh /usr/src/myapp/start.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/start.sh

RUN echo ${KAFKA_MIRROR}${KAFKA_VERSION}.tgz && curl -o /opt/${KAFKA_VERSION}.tgz ${KAFKA_MIRROR}${KAFKA_VERSION}.tgz && \
	tar -zxf /opt/${KAFKA_VERSION}.tgz -C /opt && \
	rm /opt/${KAFKA_VERSION}.tgz && ln -s /opt/${KAFKA_VERSION} /opt/kafka 

WORKDIR /opt/kafka

EXPOSE 9092

RUN chmod +x /usr/src/myapp/start.sh
ENTRYPOINT [ "/usr/src/myapp/start.sh" ]