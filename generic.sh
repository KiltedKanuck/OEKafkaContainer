#!/bin/bash
export PROPATH=.:$DLC/tty/netlib/OpenEdge.Net.pl:$DLC/tty/messaging/OpenEdge.Messaging.pl:$PROPATH
$DLC/bin/pro -b -p code/generic-producer.p | tee -a /dev/null
