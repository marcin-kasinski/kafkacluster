FROM openjdk:11
#FROM ubuntu:16.04
MAINTAINER Marcin Kasi�ski <marcin.kasinski@gmail.com> 

#ZOOKEEPER_CONNECT=x.x.x.x:2181,x.x.x.x:2181,x.x.x.x:2181
#BROKER_NODES="kafka-0.k-hs.default.svc.cluster.local:9092,kafka-1.k-hs.default.svc.cluster.local:9092,kafka-2.k-hs.default.svc.cluster.local:9092"

#ENV KAFKA_MIRROR=http://ftp.man.poznan.pl/apache/kafka/2.2.1/ \
ENV KAFKA_MIRROR=http://ftp.man.poznan.pl/apache/kafka/2.4.0/ \
#	KAFKA_VERSION=kafka_2.12-2.1.0 \
#	KAFKA_VERSION=kafka_2.12-2.2.1 \
#	KAFKA_VERSION=kafka_2.12-2.3.0 \
	KAFKA_VERSION=kafka_2.12-2.4.0 \
	ZOOKEEPER_CONNECT="mainserver:2181" \
	BROKER_NODES="mainserver.sdssd.sdsd.d,mainserver2" \
	CONFIG="/opt/kafka/config/server.properties" \
	PROMETHEUS_JMX_AGENT_MIRROR="https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/" \
	PROMETHEUS_JMX_AGENT_VERSION="0.3.1" \
	PROMETHEUS_JMX_AGENT_PORT="8080"

	
ENV KAFKA_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=${PROMETHEUS_JMX_AGENT_PORT}:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent_kafka.yaml

RUN mkdir /usr/src/myapp && mkdir /opt/jmx_prometheus_javaagent

ADD jmx_prometheus_javaagent/jmx_prometheus_javaagent_kafka.yaml /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent_kafka.yaml

ADD libs.sh /usr/src/myapp/libs.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/libs.sh
ADD start.sh /usr/src/myapp/start.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/start.sh

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y krb5-user && echo ${KAFKA_MIRROR}${KAFKA_VERSION}.tgz && curl -o /opt/${KAFKA_VERSION}.tgz ${KAFKA_MIRROR}${KAFKA_VERSION}.tgz && \
	tar -zxf /opt/${KAFKA_VERSION}.tgz -C /opt && \
	rm /opt/${KAFKA_VERSION}.tgz && ln -s /opt/${KAFKA_VERSION} /opt/kafka && \
	curl -o /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent-${PROMETHEUS_JMX_AGENT_VERSION}.jar ${PROMETHEUS_JMX_AGENT_MIRROR}${PROMETHEUS_JMX_AGENT_VERSION}/jmx_prometheus_javaagent-${PROMETHEUS_JMX_AGENT_VERSION}.jar && \
	ln -s /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent-${PROMETHEUS_JMX_AGENT_VERSION}.jar /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar && \
	sed -i -e 's/\r//g' /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent_kafka.yaml && echo export PATH=\"/opt/kafka/bin:\$PATH\" >>  /root/.bashrc
	

WORKDIR /opt/kafka

EXPOSE 9092 8080

RUN chmod +x /usr/src/myapp/start.sh
ENTRYPOINT [ "/usr/src/myapp/start.sh" ]