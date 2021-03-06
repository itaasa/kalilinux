#!/bin/bash

APMAC=$1
PSKFILE=$2

# Killing any other aircrack process that may have not terminated
CRACKPID=`ps -ef | grep "\baircrack\b" | awk '{print $2}'`
echo aircrack-ng processes found: $CRACKPID
sleep 1

if [ -n "$CRACKPID" ]; then
	echo Killing these processes
	kill -15 $CRACKPID
else
	echo "No such processes were found."
fi

echo

# Display wordlists found in wordlists/ to attacker
cd wordlists
WORDLISTS=(*)

COUNT=0

echo "Wordlists available:"
echo
for WORDLIST in "${WORDLISTS[@]}"
do
	((COUNT++))
	echo $COUNT. $WORDLIST
done


# Allows user to choose available wordlists
echo
read -p "Enter choice [1-${#WORDLISTS[@]}]: " CHOICE
((CHOICE--))

WORDLIST=${WORDLISTS[$CHOICE]}

echo Now using wordlist: $WORDLIST...
sleep 1
cd ..

x-terminal-emulator -e "aircrack-ng -w wordlists/$WORDLIST -b $APMAC crackfiles/"$PSKFILE"*.cap ; bash" &
echo 

#Prompts user to exit aircrack by pressing enter
read -p "Press <enter> to exit aircrack... " 
read -p "Are you sure [Y/N]? " RESPONSE
case $RESPONSE in
	[Yy]* ) ./end_test.sh ;;
	[Nn]* ) echo Continuing aircrack... ;;
	* ) echo "Entered invalid response..." ;;
esac

echo

while [ ! "$RESPONSE" = "Y" ] && [ ! "$RESPONSE" = "y" ]
do
	read -p "Press <enter> to exit aircrack... " 
	read -p "Are you sure [Y/N]? " RESPONSE
	
	case $RESPONSE in
		[Yy]* ) ./end_test.sh ;;
		[Nn]* ) echo Continuing aircrack... ;;
		* ) echo Entered invalid response... ;;
	esac

	echo 
done
