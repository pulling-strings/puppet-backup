#!/bin/bash

# Name of the traffic control command.
TC=/sbin/tc

# The network interface we're planning on limiting bandwidth i.e eth0 
IF=$2 # Interface

# Upload limit (in mega bits) like 45kbps 
UPLD=$3 # UPLOAD Limit

# Filter options for limiting the intended interface.
U32="$TC filter add dev $IF protocol ip parent 1:0 prio 1 u32"

start() {

$TC qdisc add dev $IF root handle 1: htb default 30
#$TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD
$TC class add dev $IF parent 1: classid 1:2 htb rate $UPLD
#$U32 match ip dst $IP/32 flowid 1:1, $4 is outgoing port number (2222)
$U32 match ip dport $4 0xffff flowid 1:2
}

stop() {
$TC qdisc del dev $IF root

}

restart() {
stop
sleep 1
start
}

show() {
$TC -s qdisc ls dev $IF
}

case "$1" in
start)
echo -n "Starting bandwidth shaping: "
start
echo "done"
;;

stop)
echo -n "Stopping bandwidth shaping: "
stop
echo "done"
;;

restart)
echo -n "Restarting bandwidth shaping: "
restart
echo "done"
;;

show)
echo "Bandwidth shaping status for $IF:"
show
echo ""
;;

*)
pwd=$(pwd)
echo "Usage: tc.bash {start|stop|restart|show}"
;;

esac

exit 0
