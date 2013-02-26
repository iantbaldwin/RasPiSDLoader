#!/bin/bash 
# Made by Ian Baldwin
# 2/25/2013

# Find SD Card

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

echo "Image restore will now begin"

# See if SD is present
diskPres=$(ls /dev/ | grep -xc $sdCard)
exptAns='1'

if [ "$diskPres" -eq "$exptAns" ]
then
echo "Disk found..."
echo "Unmounting disk"

# Seeing if unmount was successful
sucUn=$(diskutil unmountDisk /dev/$sdCard | grep -ci 'successful')
if [ "$sucUn" -eq "$exptAns" ] 
then
echo "Disk unmounted"

# Restoring SD card from supplied image
echo "Drag preferred OS ing into Terminal and press [ENTER]:"
read -e RPImage 
sudo dd bs=1m if=$RPImage of=/dev/$sdCard

# Verify successful restore

# Get disk name
sleep 5
echo $sdCard's1' > /tmp/sDrive.txt
sdCard=$(awk '{print $1}' /tmp/sDrive.txt)
echo $sdCard
diskutil info /dev/$sdCard | grep -i 'Mount Point:' > /tmp/volNameInt.txt
volNameFin=$(awk '{print $3}' /tmp/volNameInt.txt)
echo Volume mounted at :$volNameFin
rm -rf /tmp/volNameInt.txt

# Check if config.txt is there
sucRe=$(ls $volNameFin | grep -xci 'config.txt')
if [ "$sucRe" -eq "$exptAns" ]
then
echo "Disk successfully created"
echo "Disk will now be ejected"

# Eject Disk
diskutil eject /dev/$sdCard > /dev/null 2

# Check if disk is ejected
dEJCT=$(ls /dev/ | grep -xci $sdCard)
exptAns='0'
if [ "$dEJCT" -eq "$exptAns" ]
then 
echo "Disc ejected. Enjoy your Pi"
# Done
fi
else
echo "Disk was not created successfully"
fi

else
echo "Error:Disk failed to unmount properly"
# Bad unmount (Will add force unmount)
diskTh=$(diskutil list | grep -xc $sdCard)
if [ "$diskTh" -eq "$exptAns" ] 
then
echo "Disk appears to be mounted"
echo "Will attempt to force unmount"
fi
fi
fi