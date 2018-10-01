#!/bin/bash
source /usr/src/myapp/libs.sh

echo "Starting..."

cp $CONFIG $CONFIG.OLD
echo "" >$CONFIG

HOSTNAME_FQDN=`hostname -f`

#if [ "$AUTH_TYPE" == "SASL_PLAINTEXT" ]; then 
EXTRA_KAFKA_OPTS="$KAFKA_OPTS $EXTRA_JAVA_ARGS -Djava.security.auth.login.config=$JAAS_FILE_LOCATION"
#fi

processBROKER_NODES

process_param_config

echo replacing {HOSTNAME_FQDN} with $HOSTNAME_FQDN
cp $JAAS_FILE_LOCATION_RO $JAAS_FILE_LOCATION
sed -i -e 's/{HOSTNAME_FQDN}/'"$HOSTNAME_FQDN"'/g' $JAAS_FILE_LOCATION
cat $JAAS_FILE_LOCATION

echo "Configuration"
cat $CONFIG

echo copy /opt/kafka/config/$HOSTNAME.service.keytab to /opt/kafka/config/kafka.service.keytab

cp /opt/kafka/config/$HOSTNAME.service.keytab /opt/kafka/config/kafka.service.keytab

KAFKA_OPTS=$EXTRA_KAFKA_OPTS /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
sleep 600000
