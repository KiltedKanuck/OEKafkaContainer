#!/bin/bash
export PROPATH=.:$DLC/tty/netlib/OpenEdge.Net.pl:$DLC/tty/messaging/OpenEdge.Messaging.pl:$PROPATH
$DLC/bin/pro -p code/consume.p
