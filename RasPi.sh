#!/bin/bash 
# Made by Ian Baldwin
# 2/25/2013
function countdown
{
        local OLD_IFS="${IFS}"
        IFS=":"
        local ARR=( $1 )
        local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
        local START=$(date +%s)
        local END=$((START + SECONDS))
        local CUR=$START

        while [[ $CUR -lt $END ]]
        do
                CUR=$(date +%s)
                LEFT=$((END-CUR))

                printf "\r%02d:%02d:%02d" \
                        $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

                sleep 1
        done
        IFS="${OLD_IFS}"
        echo "        "
}


echo "Please eject all external media and insert your RasPi SD card"
countdown "00:00:15"
echo "Image restore will now begin"

# See if rdisk1 is present (Should be the SD card if nothing else is hooked up)
diskPres=$(ls /dev/ | grep -xc 'rdisk1')
exptAns='1'

if [ "$diskPres" -eq "$exptAns" ]
then
echo "Disk found..."
echo "Unmounting disk"

# Seeing if unmount was successful
sucUn=$(diskutil unmountDisk /dev/rdisk1 | grep -ci 'successful')
if [ "$sucUn" -eq "$exptAns" ] 
then
echo "Disk unmounted"

# Restoring SD card from supplied image
echo "Drag Distro into Terminal and press [ENTER]:"
echo "Drag preferred OS ing into Terminal and press [ENTER]:"
read -e RPImage 
sudo dd bs=1m if=$RPImage of=/dev/rdisk1

# Verify successful restore

# Get disk name
sleep 5
diskutil info /dev/rdisk1s1 | grep -i 'Mount Point:' > /tmp/volNameInt.txt
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
diskutil eject /dev/rdisk1
diskutil eject /dev/rdisk1 > /dev/null 2

# Check if disk is ejected
dEJCT=$(ls /dev/ | grep -xci "rdisk1")
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
diskTh=$(diskutil list | grep -xc 'rdisk1')
if [ "$diskTh" -eq "$exptAns" ] 
then
echo "Disk appears to be mounted"
echo "Will attempt to force unmount"
fi
fi
fi