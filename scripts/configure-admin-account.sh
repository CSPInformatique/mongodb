LOG_FILE=/var/log/mongodb.log
SCRIPT_FILE=/scripts/create-admin-account.js
ADMIN_CREATED_FLAG=/config/admin-created.flag

# Wait until mongo logs that it's ready (or timeout after 60s)
echo "Waiting for mongo to initialize."
COUNTER=0
grep -q 'waiting for connections on port' $LOG_FILE
while [[ $? -ne 0 && $COUNTER -lt 200 ]] ; do
    sleep 1
    let COUNTER+=1
    grep -q 'waiting for connections on port' $LOG_FILE
done

# Now we know mongo is ready and can continue with other commands

if [ ! -f $ADMIN_CREATED_FLAG ]; then
    echo "Admin user does not exists."

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
fi
