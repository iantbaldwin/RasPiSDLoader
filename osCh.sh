#!/bin/bash
echo "Please enter your desired OS to download and install on your Raspberry Pi SD:"
echo "Avaliable OS's are Wheezy, Soft-Point Wheezy, Arch Linux, and Risc OS"
read -e osCh
if [ "$osCh" = 'Wheezy' ]
then
echo Downloading Debian Wheezy 
elif [ "$osCh" = 'Soft-Point Wheezy' ]
then
echo Downloading Soft-Point Debian Wheezy
elif [ "$osCh" = 'Arch Linux' ]
then
echo Downloading Arch Linux ARM
elif [ "$osCh" = 'Risc OS' ]
then
echo Downloading Risc OS
else
echo "No OS selected"
fi

# curl the download database and awk to get OS Names