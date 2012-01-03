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
function get_overall_bad()
{
   match=`scribe_ctrl counters $SCRIBEPORT | grep -w ^scribe_overall:sent:`
   [[ $match ]] && echo $match | awk '{print $2}' || echo -1
   unset $match
}

