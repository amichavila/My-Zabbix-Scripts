#!/bin/bash

#
# This script sends <PINGS> ping packages to <HOST>
# if can't ping host then shows an <ALERT>.
# Until you term this script, it will keep on sending
# packages every <SLEEP> seconds.
#

HOST="8.8.8.8"
PINGS=3
ALERT="Can't ping $HOST"
OK="Network's OK"
SLEEP=5

while true ;
do
    ping -c $PINGS $HOST > /dev/null

    if [ $? -ne 0 ] ; 
    then
       echo $ALERT
    else
       echo $OK
    fi

    sleep "$SLEEP"s
done
