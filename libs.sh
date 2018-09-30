
processBROKER_NODES(){


nodes=$(echo $BROKER_NODES | tr "," "\n")

HOSTNAME=`hostname -f`
#HOSTNAME=mainserver.sdssd.sdsd.d

echo HOSTNAME=[$HOSTNAME]

echo listing nodes

INDEX=1;

for SERVER in $nodes
do

	SERVER=`echo $SERVER | cut -d ":" -f 1`

	echo server :$SERVER index $INDEX

    if [ "$SERVER" == "$HOSTNAME" ]; then
          echo "Strings match $SERVER $INDEX"

      	  echo "found server in env  $SERVER $INDEX"
          echo "broker.id=$INDEX" >> $CONFIG
    fi

	INDEX=$((INDEX + 1))
	
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

echo "process_param_config()"

for line in $(set); do
	KEY=`echo $line | cut -d "=" -f 1`
	#echo "KEY $KEY"
	VALUE=`echo $line | cut -d "=" -f 2`
	#echo "VALUE $VALUE"
	# replace %HOSTNAME%
    #VALUE=${VALUE//[\%HOSTNAME\%]/$HOSTNAME}
    VALUE=${VALUE//\{HOSTNAME\}/$HOSTNAME}
    #VALUE=${VALUE//'}
    #remove '
    #VALUE=${VALUE//'}
	#echo "VALUE $VALUE"

	VALUE=`echo $VALUE | cut -d "'" -f 2`

	[[ $KEY =~ ^"$param_prefix" ]] && add_param_to_config $KEY $VALUE
	
done

}
