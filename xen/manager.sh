#!/bin/bash

runpy='/usr/bin/env python'
logfile='manager.log'
xenserver=''
xenprotocol=''
xenport=''
xenuser=''
xenpassword=''
zbxapiurl=''
zbxuser=''
zbxpass=''

#
# Main Code
#

echo "[START] [`date`] -- Manager Started" >> $logfile
echo '>> Starting manager <<'
# Get all host (name) from zabbix
echo '  * Getting all host (name) from zabbix.'
hosts=`$runpy zbx_getallhosts.py --url=$zbxapiurl --user=$zbxuser --password=$zbxpass 2>>$logfile`

# Check if hosts is defined
[[ ! $hosts ]] && echo "  [ERROR] 'hosts' variable is not defined. Exiting..." && exit 1

# For each host in $hosts count its vbds
for host in hosts ;
do
   resp=`$runpy getvbds.py --server=$xenserver --protocol=$xenprotocol --port=$xenport --user=$xenuser --password=$xenpassword --vmname=$host 2>>$logfile`
   [[ "$resp" = "ERROR" ]] && echo "  * An error has ocurred when runnning getvbds.py with --vmname=$host" || echo "  * $host: $resp vbds"
   echo '> Finished'
done
