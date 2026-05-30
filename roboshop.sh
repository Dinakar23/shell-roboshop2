#!/bin/bash

AMI ID=ami-0220d79f3f480ecf5
DOMAIN_NAME=dinakardevops.online
ZONE_ID = Z0522495674LVI9OE7CB



for instance in "$@"
do 
    echo "Laucnching $instance Instance "
    INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-groups "roboshop-common" "roboshop-$instance" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]' \
    --query 'Instances[0].InstanceId' \
    --output text)
    echo "Instance ID : $INSTANCE_ID"
    if [ "$instance" == "frontend"]; then
        IP=$(aws ec2 describe-instances     --instance-ids $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].[ PublicIpAddress]' \
        --output text)
        R53_RECORD="$DOMAIN_NAME"
    else 
        IP=$(aws ec2 describe-instances     --instance-ids $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].[ PrivateIpAddress]' \
        --output text)
        R53_RECORD="$instance"."$DOMAIN_NAME"
    fi

    #Updating route 53 record
    aws route53 change-resource-record-sets \
        --hosted-zone-id Z0522495674LVI9OE7CB \
        --change-batch '{
            "Comment": "Updating mongodb record",
            "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                "Name": "$R53_RECORD",
                "Type": "A",
                "TTL": 1,
                "ResourceRecords": [
                    {
                    "Value": "$IP"
                    }
                ]
                }
            }
            ]
        }'



done