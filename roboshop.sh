#!/bin/bash

AMI ID=ami-0220d79f3f480ecf5
ZONE_NAME=dinakardevops.online
ZONE_ID = Z0522495674LVI9OE7CB

if [ $# -nt 2 ]; then
    echo "ERROR Atleast provide 2 arguments "
    echo " USAGE : [create/delete] [instance1][instance2]"
    exit 1
fi 

ACTION=$1
shift

if [ "$ACTION" != "create"] && [ "$ACTION" != "delete" ]; then
    echo "The first argument must be  [create/delete] "
    echo " USAGE : [create/delete] [instance1][instance2]"
    exit 1
fi 

get_instance_id(){
    NAME=$1
    aws ec2 describe-instances --filters "Name=tag:Name,Values=Robosho-$NAME" --query 'Reservations[].Instances[].InstanceId' --output text
}

for instance in "$@"
do 
    INSTANCE_ID=$(get_instance_id $instance)
    if 
done