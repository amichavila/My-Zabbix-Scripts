#!/bin/bash

#############################################
## This script gather data from scibe servers
# Created by blackhawk (LuchoLopez)
# <luislopez72@gmail.com>
#############################################


#
# Functions
#

function helpme()
{
cat << EOF
++++++++++++
>> Usage: `basename $0` [item,listen_port,[<sending port>,<storage folder>,<error message>,<debug>]]

Items:
   status: Retrives the scribe status. 0 = ALIVE else, show \$ERRORMSG'
   good: Retrives the number of messages received since Scribe Server was started (scribe overall value).'
   bad: Retrives the number of invalid messages received (scrive overall value).'
   sent: Retrives the number of messages sent to another Scribe Server (scribe overall value).'
   deniedfqs: Retrives the number of requests denied due to a full message queue (scribe overall value).'
   deniedfr: Retrives the number of requests denied due to rate limitting (scribe overall value).'
   retries: Retrives the Number of times a Buffer Store had to retry logging a batch of messages (scribe overall value).'
   requeue: Retrives the number of times Scribe had to retry sending messages to a store (scribe overall value). VIEW NOTES'
   lost: Retrives the number of messages that were not logged (scribe overall value). VIEW NOTES'
   blankcategory: Retrives the number of messages received without a message category (scribe overall value).'
   storage: Retrives the size of storage folder in bytes.'
   inconn: get the established incomming connections to LISTENPORT.'
   outconn: get the established outgoing connections to SENDINGPORT.'

NOTES:
  * debug: To enable debug set this param with 'true'
  * If you do not need a specific parameter, set it to "null". Ex.: (from zabbix) request: scribe[good,1465,null,null,null,true]
  * Requeue only works if must_succeed is enabled.
  * Lost recommended scribe configuration: Use BufferStores to avoid lost messages.
++++++++++++++
EOF
  exit 0
}

# Print 1 if status="ALIVE", else print $ERRORMSG.
function get_scribe_status
{
   local status=`scribe_ctrl status $LISTENPORT 2>/dev/null`
   [[ $status = "ALIVE" ]] && echo 1 || echo $ERRORMSG 	
}

function get_counter()
{
   local match=`scribe_ctrl counters $LISTENPORT 2>/dev/null | grep -w "^scribe_overall:$1:"`
   [[ $match ]] && echo $match | awk '{print $NF}' || echo $ERRORMSG
}

# Print the size of a folder in bytes, else print $ERRORMSG
function get_size()
{
   local size=`du -bs $1 2>/dev/null`
   [[ $size ]] && echo $size | awk '{print $1}' || echo $ERRORMSG
}

function get_incomming_conn()
{
   local incomming=`netstat -t | grep 'ESTABLISHED' | awk '{print $4}' | grep :$LISTENPORT | wc -l 2>/dev/null`
   [[ $incomming ]] && echo $incomming || echo $ERRORMSG
}

function get_outgoing_conn()
{
   local outgoing=`netstat -t | grep 'ESTABLISHED' | awk '{print $5}' | grep :$SENDINGPORT | wc -l 2>/dev/null`
   [[ $outgoing ]] && echo $outgoing || echo $ERRORMSG
}

function debuging()
{
cat << EOF

[ DEBUG ]
Item = $item
Listen Port = $LISTENPORT
Sending Port = $SENDINGPORT
Store Folder = $STORAGEFOLDER
Error Message = $ERRORMSG
Debug = $DEBUG

EOF
}

#
# Main code
#

DEBUG=
LISTENPORT=1465
STORAGEFOLDER='/var/log/scribe/store'
ERRORMSG=0
SENDINGPORT=1463

# Check if I received params
[[ $# -eq 0 ]] && echo "Please, use $0 -h or --help." && exit 1

item=$1
LISTENPORT=$2
SENDINGPORT=$3
STORAGEFOLDER=$4
ERRORMSG=$5
DEBUG=$6

[[ $LISTENPORT = "null" ]] && LISTENPORT=1465
[[ $SENDINGPORT = "null" ]] && SENDINGPORT=1463
[[ $STORAGEFOLDER = "null" ]] && STORAGEFOLDER="/var/log/scribe/store"
[[ $ERRORMSG = "null" ]] && ERRORMSG=0
[[ $DEBUG = "true" ]] && debuging

case $item in
  '-h' | '--help') helpme ;;
  'status') get_scribe_status ;;
  'good') get_counter "received good" ;;
  'bad') get_counter "received bad" ;;
  'sent') get_counter "sent" ;;
  'deniedfqs') get_counter "denied for queue size" ;;
  'deniedfr') get_counter "denied for rate" ;;
  'retries') get_counter "retries" ;;
  'requeue') get_counter "requeue" ;;
  'lost') get_counter "lost" ;;
  'blankcategory') get_counter "blank category" ;;
  'storage') get_size "$STORAGEFOLDER" ;;
  'inconn') get_incomming_conn ;;
  'outconn') get_outgoing_conn ;;
  *)  echo 'FUCK YOU' #echo 'ZBX_NOTSUPPORTED'
esac


