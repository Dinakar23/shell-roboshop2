#!/bin/bash
LOGS_FOLDER="/var/log/roboshop2"
sudo mkdir -p $LOGS_FOLDER
sudo chown -R ec2-user:ec2-user $LOGS_FOLDER
sudo chmod -R 755 $LOGS_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log "

 USER_ID=$( id -u)
 if [ "$USER_ID" -ne 0 ]; then
    echo "Run this script with root access ..." |tee -a $LOGS_FILE
    exit 1
fi

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo " Failed" |tee -a $LOGS_FILE
    else
        echo " Success" |tee -a $LOGS_FILE
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding mongodb repo" 