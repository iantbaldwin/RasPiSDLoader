#!/bin/bash 
exptVal='1'
         COUNTER=$(ls -1 /Volumes/ | wc -l)
	 volNum='0'
         until [  $volNum -eq $COUNTER ]; do
             sdCardTest=$(diskutil info rdisk$volNum | grep -ci 'Protocol:                 Secure Digital')
if [ "$sdCardTest" -eq "$exptVal" ]
then 
echo "rdisk$volNum" > /tmp/SDcard.txt
fi
             let volNum=volNum+1
         done
sdCard=$(awk '{print $1}' /tmp/SDcard.txt)
echo The SD card is located at: /dev/$sdCard