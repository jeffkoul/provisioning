#!/bin/bash

# downloads and installs VirtualBox on a Host machine

usage(){
  echo "USAGE: installVirtualBox.sh <version> <os>"
  exit -1
}

if [[ -z "$1" ]]; then
  usage
fi

if [[ -z "$2" ]]; then
  usage
fi

VERSION="$1"
OS="$2"
RPM_PTRN="VirtualBox-*-${VERSION}_*_${OS}-1.x86_64.rpm"

echo "Attempting to download VirtualBox rpm version '$VERSION' for os '$OS' as $RPM_PTRN..."
wget -r -np -l1 -nd -erobots=off -A "$RPM_PTRN"  "http://download.virtualbox.org/virtualbox/$VERSION/"

RPM_FILE=`find $RPM_PTRN`
echo "Downloaded VirtualBox rpm file: '$RPM_FILE'"

rpm -ivf $RPM_FILE
echo "Installed: '$RPM_FILE'"

