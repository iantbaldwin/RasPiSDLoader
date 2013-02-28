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

exptVal='1'
         COUNTER=$(ls -1 /Volumes/ | wc -l)
	 volNum='0'
         until [  $volNum -eq $COUNTER ]; do
             sdCardTest=$(diskutil info rdisk$volNum | grep -ci 'SD')
if [ "$sdCardTest" -eq "$exptVal" ]
then 
echo "rdisk$volNum" > /tmp/SDcard.txt
fi
             let volNum=volNum+1
         done
filEx=$(ls /tmp/ | grep -xci 'SDcard.txt')
exptVal='1'

if [ "$filEx" -eq "$exptVal" ]
then

# Name SD Card
sdCard=$(awk '{print $1}' /tmp/SDcard.txt)
echo The SD card is located at: /dev/$sdCard
rm -rf /tmp/SDcard.txt
echo "Image backup will now begin"


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

echo $sdCard's1' > /tmp/sDrive.txt
sdCard=$(awk '{print $1}' /tmp/sDrive.txt)
rm -rf /tmp/sDrive.txt
echo Backing up SD Card:$sdCard

# Backup SD card to image
echo "Name image (Will save to Desktop):"
read -e RPImage 
sudo dd if=/dev/$sdCard of=~/Desktop/$RPImage.img bs=1m > /dev/null

# Verify successful backup

echo Verifying backup

diskutil info $sdCard | grep 'Total Size:' > /tmp/sDrive.txt
exptVal=$(awk '{print $5}' /tmp/sDrive.txt)

rm -rf /tmp/sDrive.txt


ls -l ~/Desktop | grep $RPImage > /tmp/sDrive1.txt
dBup=$(awk '{print $5}' /tmp/sDrive1.txt)
echo '('$dBup > /tmp/sDrive1.txt
dBup=$(awk '{print $1}' /tmp/sDrive1.txt)

rm -rf /tmp/sDrive1.txt

if [ "$dBup" = "$exptVal" ]
then
echo SD Card backed up successfully
diskutil mount $sdCard
echo SD Card mounted
else
echo "Disk was not backed up successfully"
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
else
echo "SD card not found. Please make sure one is connected"
fi