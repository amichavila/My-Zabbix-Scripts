#!/bin/bash

#############################################
## This script gather data from scibe servers
# Created by blackhawk (LuchoLopez)
# <luislopez72@gmail.com>
#############################################

#
# Variables
#

SCRIBEPORT=1463
STORAGEFOLDER='/var/log/scribe/store'
ERRORMSG=-1

#
# Functions
#

function helpme()
{
  echo "Usage: $0 [item]"
  echo '   Items:'
  echo '       status: Retrives the scribe status.'
  echo '       overall_good: Retrives the number of messages received since Scribe Server was started.'
  echo '       overall_bad: Retrives the number of invalid messages received.'
  echo '       overall_sent: Retrives the number of messages sent to another Scribe Server.'
  echo '       overall_denied_for_queue_size: Retrives the number of requests denied due to a full message queue.'
  echo '       overall_denied_for_rate: Retrives the number of requests denied due to rate limitting.'
  echo '       overall_retries: Retrives the Number of times a Buffer Store had to retry logging a batch of messages.'
  echo '       overall_requeue: Retrives the number of times Scribe had to retry sending messages to a store (if must_succeed is enabled).'
  echo '       overall_lost: Retrives the number of messages that were not logged. (Recommended configuration: Use BufferStores to avoid lost messages.)'
  echo '       overall_blank_category: Retrives the number of messages received without a message category.'
  echo '       storage_size: Retrives the size of storage folder in bytes.'
  exit 0
}

# Print 0 if status="ALIVE", else print 1.
function get_scribe_status
{
   status=`scribe_ctrl status`
   [[ $status = "ALIVE" ]] && echo 0 || echo $ERRORMSG
}

# Print the counter value or -1 if grep no matchs $1
function get_counter()
{
   match=`scribe_ctrl counters $SCRIBEPORT 2>/dev/null | grep -w "^scribe_overall:$1:"`
   [[ $match ]] && echo $match | awk '{print $2}' || echo $ERRORMSG
   unset match
}

# Print the size of a folder in bytes, else print $ERRORMSG
function get_size()
{
   size=`du -bs $1` 2>/dev/null
   [[ $size ]] && echo $size | awk '{print $1}' || echo $ERRORMSG
   unset size
}

#
# Main code
#

resp=$1
case $resp in
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
  *)  echo 'ZBX_NOT_SUPPORTED'
esac
