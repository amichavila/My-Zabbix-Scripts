#!/bin/bash

# Variables globales
MAX=0
CURRENT=0
PERCENT=0

# Setear valores
  MAX=`cat /proc/sys/net/netfilter/nf_conntrack_max`
  CURRENT=`cat /proc/sys/net/netfilter/nf_conntrack_count`

  PERCENT=$(($(($CURRENT*100))/$MAX)) 


#########################################
### Codigo Principal
#########################################

echo $PERCENT

exit 0

