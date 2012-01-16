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
>> Usage: $0 [option] --item [item]

Options:
   -h or --help: Show this help.
   -i or --item: Set the item I will get from scribe.
   -l or --listen-port: Set the port that scribe server listen from incomming connections.
   -s or --sending-port: Set the port that scribe server send data to another scribe server.
   -f or --store-folder: Set the folder that scribe server use to store its data.
   -e or --error-msg: Set the error message to show when an error its detected.
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
  * Requeue only works if must_succeed is enabled.
  * Lost recommended scribe configuration: Use BufferStores to avoid lost messages.
++++++++++++++
EOF
  exit 0
}

# Print 0 if status="ALIVE", else print 1.
function get_scribe_status
{
   status=`scribe_ctrl status $LISTENPORT 2>/dev/null`
   [[ $status = "ALIVE" ]] && echo 0 || echo $ERRORMSG 	
   unset status
}

function get_counter()
{
   match=`scribe_ctrl counters $LISTENPORT 2>/dev/null | grep -w "^scribe_overall:$1:"`
   [[ $match ]] && echo $match | awk '{print $NF}' || echo $ERRORMSG
   unset match
}

# Print the size of a folder in bytes, else print $ERRORMSG
function get_size()
{
   size=`du -bs $1 2>/dev/null`
   [[ $size ]] && echo $size | awk '{print $1}' || echo $ERRORMSG
   unset size
}

function get_incomming_conn()
{
   incomming=`netstat -t | grep 'ESTABLISHED' | awk '{print $4}' | grep :$LISTENPORT | wc -l 2>/dev/null`
   [[ $incomming ]] && echo $incomming || echo $ERRORMSG
   unset incomming
}

function get_outgoing_conn()
{
   outgoing=`netstat -t | grep 'ESTABLISHED' | awk '{print $5}' | grep :$SENDINGPORT | wc -l 2>/dev/null`
   [[ $outgoing ]] && echo $outgoing || echo $ERRORMSG
   unset outgoing
}

#
# Main code
#

## Parse and set variable values
while [ $# -ge 1 ] ;
do
   case $1 in
      '-h' | '--help') helpme ;;
      '-i' | '--item') item="$2" ;;
      '-l' | '--listen-port') LISTENPORT="$2" ;;
      '-s' | '--sending-port') SENDINGPORT="$2" ;;
      '-f' | '--store-folder') STORAGEFOLDER="$2" ;;
      '-e' | '--error-msg') ERRORMSG="$2" ;;
      *) echo "Unknown parameter '$1'"
         helpme
   esac
   shift
   shift
done

[[ ! $LISTENPORT ]] && LISTENPORT=1465
[[ ! $STORAGEFOLDER ]] && STORAGEFOLDER='/var/log/scribe/store'
[[ ! $ERRORMSG ]] && ERRORMSG=-1
[[ ! $SENDINGPORT ]] && SENDINGPORT=1463

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
  *)  echo 'ZBX_NOT_SUPPORTED'
esac
