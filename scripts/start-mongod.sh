#!/bin/bash

LOG_FILE=/var/log/mongodb.log
ADMIN_CREATED_FLAG=/config/admin-created.flag
# Initialize a mongo data folder and logfile
mkdir -p /data/db
touch $LOG_FILE

# Start mongodb with logging
# --logpath    Without this mongod will output all log information to the standard output.
# --logappend  Ensure mongod appends new entries to the end of the logfile. We create it first so that the below tail always finds something
ARGS=" --config /config/mongodb.conf"
/usr/bin/mongod $ARGS & 2>&1 | tee $LOG_FILE

# Wait until mongo logs that it's ready (or timeout after 60s)
echo "Waiting for mongo to initialize."
COUNTER=0
grep -q 'waiting for connections on port' $LOG_FILE
while [[ $? -ne 0 && $COUNTER -lt 60 ]] ; do
    sleep 2
    let COUNTER+=2
    grep -q 'waiting for connections on port' $LOG_FILE
done

# Now we know mongo is ready and can continue with other commands
if [ ! -f $ADMIN_CREATED_FLAG ]; then
    echo "Admin user does not exists."
    
    /scripts/configure-admin-account.sh	
fi

exit 0
