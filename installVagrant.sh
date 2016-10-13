#!/bin/bash

# downloads and installs Vagrant on a Host machine

usage(){
  echo "USAGE: installVagrant.sh <version>"
  exit -1
}

if [[ -z "$1" ]]; then
  usage
fi


VERSION="$1"
RPM_PTRN="vagrant_${VERSION}_x86_64.rpm"

echo "Attempting to download Vagrant rpm version '$VERSION' as $RPM_PTRN..."
wget -r -np -l1 -nd -erobots=off -A "$RPM_PTRN"  "https://releases.hashicorp.com/vagrant/$VERSION/"

RPM_FILE=`find $RPM_PTRN`
echo "Downloaded Vagrant rpm file: '$RPM_FILE'"

rpm -ivf $RPM_FILE
echo "Installed: '$RPM_FILE'"

echo "installing Vagrant plugins..."
vagrant plugin install vagrant-vbguest
