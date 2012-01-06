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

#
# Functions
#

# Print 0 if status="ALIVE", else print 1.
function get_scribe_status
{
   status=`scribe_ctrl status`
   [[ $status = "ALIVE" ]] && echo 0 || echo -1
}

# Print the counter value or -1 if grep no matchs $1
function get_counter()
{
   match=`scribe_ctrl counters $SCRIBEPORT 2>/dev/null | grep -w "^scribe_overall:$1:"`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

#
# Main code
#

resp=$1
case $resp in
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
  *)  echo "ZBX_NOT_SUPPORTED"
esac
