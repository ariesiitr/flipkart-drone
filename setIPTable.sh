networkInterface="wlan0"
serverIP="192.46.215.236"
logFile="/home/pi/dronelog/ipTables.log"
networkGateway=$(/sbin/ifconfig | grep -A2 $networkInterface | grep "inet " | awk -F' ' '{print $2}' | awk -F'.' '{print $1"."$2"."$3".1"}')

while true
do
    if [! -z $networkGateway]
    then
        echo "Using gateway $networkGateway" >> logFile
        break
    else
        echo "No gateway found yet. Trying again..." >> $logFile
    fi
    sleep 10
done

setRoute=$(sudo ip route add $serverIP via $networkGateway dev $networkInterface 2>&1)
echo $setRoute >> $logFile