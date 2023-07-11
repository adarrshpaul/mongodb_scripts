#!/bin/bash
#./setup_cluster.sh 127.0.0.1 27017 127.0.0.1 27018 127.0.0.1 27019
# Set the replica set name
REPL_SET_NAME="myReplSet"

# Get the IP addresses and ports from command-line arguments
INSTANCE1_IP="$1"
INSTANCE1_PORT="$2"
INSTANCE2_IP="$3"
INSTANCE2_PORT="$4"
INSTANCE3_IP="$5"
INSTANCE3_PORT="$6"

# Initialize the replica set
echo "rs.initiate({_id: '$REPL_SET_NAME', members: [{_id: 0, host: '$INSTANCE1_IP:$INSTANCE1_PORT'}]})" | mongo --host $INSTANCE1_IP:$INSTANCE1_PORT

# Add the cluster instances
echo "rs.add('$INSTANCE2_IP:$INSTANCE2_PORT')" | mongo --host $INSTANCE1_IP:$INSTANCE1_PORT
echo "rs.add('$INSTANCE3_IP:$INSTANCE3_PORT')" | mongo --host $INSTANCE1_IP:$INSTANCE1_PORT

# Check the status of the replica set
echo "rs.status()" | mongo --host $INSTANCE1_IP:$INSTANCE1_PORT
