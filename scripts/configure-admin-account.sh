#!/bin/bash

SCRIPT_FILE=/scripts/create-admin-account.js
ADMIN_CREATED_FLAG=/config/admin-created.flag

if [ "$ADMIN_USER" != "" ] && [ "$ADMIN_PASSWORD" != "" ]
then
                echo Configuring mongodb admin account

                WORK_FILE=$SCRIPT_FILE.work
                cp $SCRIPT_FILE $WORK_FILE
                sed -i -e "s/ADMIN_USER/$ADMIN_USER/g" $WORK_FILE
                sed -i -e "s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g" $WORK_FILE
                mongo < $WORK_FILE

                echo "Deleting $WORK_FILE"
                rm $WORK_FILE

                touch $ADMIN_CREATED_FLAG

                echo MongoDB admin account configured.
fi
