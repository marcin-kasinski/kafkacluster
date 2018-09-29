#!/bin/bash
source /usr/src/myapp/libs.sh

ls -l /opt

ls -l /usr/src/myapp/


cp $CONFIG $CONFIG.OLD
echo "" >$CONFIG

HOSTNAME=`hostname -f`

#echo "advertised.host.name=$HOSTNAME" >> "$CONFIG"
#echo "zookeeper.connect=$ZOOKEEPER_CONNECT" >> "$CONFIG"
echo "advertised.listeners=$AUTH_TYPE://$HOSTNAME:9093" >> "$CONFIG"

if [ "$AUTH_TYPE" == "SASL_PLAINTEXT" ]; then 
  KAFKA_OPTS="$KAFKA_OPTS -Djava.security.auth.login.config=$JAAS_FILE_LOCATION"
fi

processBROKER_NODES
process_param_config

echo "Configuration"
cat $CONFIG

#sleep 300000
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
