
processBROKER_NODES(){

nodes=$(echo $BROKER_NODES | tr ";" "\n")

HOSTNAME=`hostname -f`
#HOSTNAME=mainserver.sdssd.sdsd.d

echo HOSTNAME=[$HOSTNAME]

echo listing nodes

for addr in $nodes
do

	echo node:            $addr
	
	INDEXWITHSERVER=`echo $addr | cut -d ":" -f 1`
	echo INDEXWITHSERVER:            $INDEXWITHSERVER
	INDEX=`echo $INDEXWITHSERVER | cut -d "=" -f 1`
	echo INDEX:            $INDEX

	SERVER=`echo $INDEXWITHSERVER | cut -d "=" -f 2`
	echo SERVER:[$SERVER]

if [ "$SERVER" == "$HOSTNAME" ]; then
    echo "Strings match"

		echo "found server index > $INDEX "
		echo "broker.id=$INDEX" >> $CONFIG
fi
	
#    echo "$addr" >> /opt/zookeeper/conf/zoo.cfg
done

}
