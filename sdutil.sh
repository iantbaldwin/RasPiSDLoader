#!/bin/bash

usage()
{
cat << EOF
usage: $0 options
OPTIONS:
   -h      Show this message
   -b      Backup SD Card to image
   -r      Restore SD Card from image
   -c      Copy config to SD Card
EOF
}


restore()
{
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
echo "Drag preferred OS .img into Terminal and press [ENTER]:"
read -e RPImage 
sudo dd bs=1m if=$RPImage of=/dev/$sdCard > /dev/null

# Verify successful restore

# Get disk name
sleep 5
echo $sdCard's1' > /tmp/sDrive.txt
sdCard=$(awk '{print $1}' /tmp/sDrive.txt)
rm -rf /tmp/sDrive.txt

diskutil info /dev/$sdCard | grep -i 'Mount Point:' > /tmp/volNameInt.txt
volNameFin=$(awk '{print $3}' /tmp/volNameInt.txt)
echo Volume created at :$volNameFin
rm -rf /tmp/volNameInt.txt

# Check if config.txt is there
sucRe=$(ls $volNameFin | grep -xci 'config.txt')
if [ "$sucRe" -eq "$exptAns" ]
then
echo "Disk successfully created"
echo "Disk will now be mounted"

# Eject Disk
diskutil mount /dev/$sdCard > /dev/null 2>&1

# Check if disk is mounted
dEJCT=$(ls /dev/ | grep -xci $sdCard)
exptAns='1'
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
else
echo "SD card not found. Please make sure one is connected"
fi
}


backup()
{
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
echo $RPImage'.img' > /tmp/sDrive.txt
exptVal=$(awk '{print $1}' /tmp/sDrive.txt)
rm -rf /tmp/sDrive.txt
rm -rf ~/Desktop/$RPImage
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
}

while getopts "brch:" OPTION
do
     case $OPTION in
         h)
             usage
             exit
             ;;
         b)
           backup
            ;;
         r)
	    restore
            ;;
         c)
            echo "You have selected image copy config. This is not yet supported"
	    exit 1
            ;;
         *)
             usage
             exit
             ;;
     esac
done
if [ $# -eq 0 ] ; then
    usage
    exit 1
fi 