#!/bin/bash

# per directions found at https://www.vagrantup.com/docs/virtualbox/boxes.html
# this script is intended to be run from INSIDE of a Vagrant VM
# (i.e. the Guest machine)

usage(){
  echo "USAGE: installVirtualBoxGuestAdd.sh <version>"
  exit -1
}

if [[ -z "$1" ]]; then
  usage
fi

VERSION="$1"
ISO_PTRN="VBoxGuestAdditions_${VERSION}.iso"

echo "Attempting to download VirtualBox Guest Additions version '$VERSION' as $ISO_PTRN..."
wget -r -np -l1 -nd -erobots=off -A "$ISO_PTRN"  "http://download.virtualbox.org/virtualbox/$VERSION/"

ISO_FILE=`find $ISO_PTRN`
echo "Downloaded VirtualBox Guest Additions file '$ISO_FILE'"

sudo mkdir -pv /media/VBoxGuestAdditions
sudo mount -o loop,ro $ISO_FILE /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
#rm $ISO_FILE
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions

