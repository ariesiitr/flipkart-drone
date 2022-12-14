networkInterface="wlan0"
serverIP="192.46.215.236"
logFile="/home/pi/dronelog/serverConnection.log"
IPFound=0

while True
do
	currentSelfIP=$(/usr/sbin/ifconfig | grep -A2 $networkInterface | grep "inet " | awk -F' ' '{print $2}')
	date=$(date)
	
	if [-z "$currentSelfIP"]
	then
		echo "ifconfig starting up..." >> $logFile
	elif [$IPFound==0]
	then
		echo $date: "Found IP Address for $networkInterface: $currentSelfIP" >> $logFile
		echo "Found IP adress for $networkInterface: $currentSelfIP"
		IPFound=1
	fi

	echo "$date: SSHing with IP Address $currentSelfIP" >> logFile
	echo "SSHing with IP Address $currentSelfIP"

	ssh -b $networkInterface -f -N -T -R 2222:localhost:22 ubuntu@$serverIP -p 5000

	if [$? -eq 0]
	then
		echo "$date: Successful detection of reverse SSH tunnel" >> logFile
		echo "Successful detection of reverse SSH tunnel"
		break
	fi

	echo "$date: Attempt to initiate reverse SSH tunnel failed. Trying again." >> logFile
	echo "Attempt to initiate reverse SSH tunnel failed. Trying again."
	sleep 10
done

echo "------------------------------------" >> logFile