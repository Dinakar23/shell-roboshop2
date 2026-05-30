#!/bin/bash

USER_ID=$( id  -u)
 
 if [ "$USER_ID" -ne 0]; then
    echo "Run this script with sudo access ..."
    exit 1
fi

dnf list installed mysql
 if [ $? -ne 0 ]; then
    echo "Installing Mysql"
    dnf install mysql -y
    if [ $? -ne 0 ]; then
        echo "Installation Failed"
    else
        echo "Installation Success"