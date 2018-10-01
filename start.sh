#!/bin/bash
source /usr/src/myapp/libs.sh

cp $CONFIG $CONFIG.OLD
echo "" >$CONFIG

HOSTNAME=`hostname -f`

#echo "advertised.host.name=$HOSTNAME" >> "$CONFIG"
#echo "zookeeper.connect=$ZOOKEEPER_CONNECT" >> "$CONFIG"
#echo "advertised.listeners=PLAINTEXT://$HOSTNAME:9093,$AUTH_TYPE://$HOSTNAME:9094" >> "$CONFIG"



#if [ "$AUTH_TYPE" == "SASL_PLAINTEXT" ]; then 
KAFKA_OPTS="$KAFKA_OPTS -Djava.security.auth.login.config=$JAAS_FILE_LOCATION"
#fi

processBROKER_NODES

process_param_config

echo replacing {HOSTNAME}
cp $JAAS_FILE_LOCATION_RO $JAAS_FILE_LOCATION
sed -i -e 's/{HOSTNAME}/"$HOSTNAME"/g' $JAAS_FILE_LOCATION


echo "Configuration"
cat $CONFIG

/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
sleep 600000
