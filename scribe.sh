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
Usage: $0 [option] --item [item]

Options:
   -h or --help: Show this help.
   -i or --item: Set the item I will get from scribe.
   -l or --listen-port: Set the port that scribe server listen from incomming connections.
   -s or --sending-port: Set the port that scribe server send data to another scribe server.
   -f or --store-folder: Set the folder that scribe server use to store its data.
   -e or --error-msg: Set the error message to show when an error its detected.
Items:
   status: Retrives the scribe status. 0 = ALIVE else, show $ERRORMSG'
   overall_good: Retrives the number of messages received since Scribe Server was started.'
   overall_bad: Retrives the number of invalid messages received.'
   overall_sent: Retrives the number of messages sent to another Scribe Server.'
   overall_denied_for_queue_size: Retrives the number of requests denied due to a full message queue.'
   overall_denied_for_rate: Retrives the number of requests denied due to rate limitting.'
   overall_retries: Retrives the Number of times a Buffer Store had to retry logging a batch of messages.'
   overall_requeue: Retrives the number of times Scribe had to retry sending messages to a store (if must_succeed is enabled).'
   overall_lost: Retrives the number of messages that were not logged. (Recommended configuration: Use BufferStores to avoid lost messages.)'
   overall_blank_category: Retrives the number of messages received without a message category.'
   storage_size: Retrives the size of storage folder in bytes.'
   inconn: get the established incomming connections to LISTENPORT.'
   outconn: get the established outgoing connections to SENDINGPORT.'
EOF
  exit 0
}

# Print 0 if status="ALIVE", else print 1.
function get_scribe_status
{
   status=`scribe_ctrl status 2>/dev/null`
   [[ $status = "ALIVE" ]] && echo 0 || echo $ERRORMSG 	
   unset status
}

function get_counter()
{
   match=`scribe_ctrl counters $LISTENPORT 2>/dev/null | grep -w "^scribe_overall:$1:"`
   [[ $match ]] && echo $match | awk '{print $2}' || echo $ERRORMSG
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
      *) echo "Unknown parameter '$1' '$2'"
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
  'overall_good') get_counter "received good" ;;
  'overall_bad') get_counter "received bad" ;;
  'overall_sent') get_counter "sent" ;;
  'overall_denied_for_queue_size') get_counter "denied for queue size" ;;
  'overall_denied_for_rate') get_counter "denied for rate" ;;
  'overall_retries') get_counter "retries" ;;
  'overall_requeue') get_counter "requeue" ;;
  'overall_lost') get_counter "lost" ;;
  'overall_blank_category') get_counter "blank category" ;;
  'storage_size') get_size "$STORAGEFOLDER" ;;
  'inconn') get_incomming_conn ;;
  'outconn') get_outgoing_conn ;;
  *)  echo 'ZBX_NOT_SUPPORTED'
esac
