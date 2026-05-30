#!/bin/bash
LOGS_FOLDER="/var/log/roboshop2"
sudo mkdir -p $LOGS_FOLDER
sudo chown -R ec2-user:ec2-user $LOGS_FOLDER
sudo chmod -R 755 $LOGS_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log "
TIMESTAMP=$(date '+%Y-%M-%D %H:%M:%S')

 USER_ID=$( id -u)
 if [ "$USER_ID" -ne 0 ]; then
    echo "$TIMESTAMP [ERROR] Run this script with root access ..." |tee -a $LOGS_FILE
    exit 1
fi

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo "$TIMESTAMP [ERROR] $2 Failed" |tee -a $LOGS_FILE
    else
        echo "$TIMESTAMP [INFO] $2 Success" |tee -a $LOGS_FILE
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding mongodb repo" 

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "Installing Mongodb"

systemctl enable mongod 
systemctl start mongod 
VALIDATE $? "Mongodb enabled and started "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote access to Mongodb"

systemctl restart mongod
VALIDATE $? "Restarting Mongodb"
