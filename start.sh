#!/bin/bash
source /usr/src/myapp/libs.sh

cp $CONFIG $CONFIG.OLD
echo "" >$CONFIG

HOSTNAME_FQDN=`hostname -f`

#if [ "$AUTH_TYPE" == "SASL_PLAINTEXT" ]; then 
KAFKA_OPTS="$KAFKA_OPTS -Djava.security.auth.login.config=$JAAS_FILE_LOCATION"
#fi

processBROKER_NODES

process_param_config

echo replacing {HOSTNAME_FQDN} with $HOSTNAME_FQDN
cp $JAAS_FILE_LOCATION_RO $JAAS_FILE_LOCATION
sed -i -e 's/{HOSTNAME_FQDN}/'"$HOSTNAME_FQDN"'/g' $JAAS_FILE_LOCATION
cat $JAAS_FILE_LOCATION

echo "Configuration"
cat $CONFIG

cp /opt/kafka/config/$HOSTNAME.service.keytab /opt/kafka/config/kafka.service.keytab

/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
sleep 600000
