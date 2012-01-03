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

# Get the scribe counter for 'scribe_overall:received good:'
# Print -1 if it not exist.
function get_overall_good()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:received\ good:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:received bad:'
# Print -1 if it not exist.
function get_overall_bad()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:received\ bad:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:sent:'
# Print -1 if it not exist.
function get_overall_sent()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:sent:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:denied for queue size:'
# Print -1 if it not exist.
function get_overall_denied_for_queue_size()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:denied\ for\ queue\ size:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:denied for rate:'
# Print -1 if it not exist.
function get_overall_denied_for_rate()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:denied\ for\ rate:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}


# Get the scribe counter for 'scribe_overall:retries:'
# Print -1 if it not exist.
function get_overall_retries()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:retries:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:requeue:'
# Print -1 if it not exist.
function get_overall_requeue()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:requeue:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:lost:'
# Print -1 if it not exist.
function get_overall_lost()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:lost:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

# Get the scribe counter for 'scribe_overall:received blank category:'
# Print -1 if it not exist.
function get_overall_blank_category()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:received\ blank\ category:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}


