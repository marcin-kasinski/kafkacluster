#!/bin/bash
source /usr/src/myapp/libs.sh

ls -l /opt

ls -l /usr/src/myapp/


cp $CONFIG $CONFIG.OLD
echo "" >$CONFIG

HOSTNAME=`hostname -f`

echo "advertised.host.name=$HOSTNAME" >> "$CONFIG"
echo "zookeeper.connect=$ZOOKEEPER_CONNECT" >> "$CONFIG"


processBROKER_NODES


cat /opt/kafka/config/server.properties

/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
