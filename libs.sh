
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



param_prefix="KAFKA_PARAM_"

add_param_to_config()
{
local key=$1
local value=$2

#remove prefix
key=${key#"$param_prefix"}
#replace _ with .
key=${key//[_]/.}
#lowercase
key=${key,,}

echo "adding line to config key ["$key"] value ["$value"]"
echo "$key=$value" >> $CONFIG
}

process_param_config()
{


for line in $(set); do
	KEY=`echo $line | cut -d "=" -f 1`
	VALUE=`echo $line | cut -d "=" -f 2`

	[[ $KEY =~ ^"$param_prefix" ]] && add_param_to_config $KEY $VALUE
	
done

}
