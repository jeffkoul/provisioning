#!/bin/bash

# downloads and installs Git SCM on a Host machine

PKG_DIR=/tmp/packages
mkdir -p $PKG_DIR

# !!! SPECIFY THE SPECIFIC VERSION HERE !!!
MAJOR=2
MINOR=10

UNPACKED="git-${MAJOR}.${MINOR}.0"
PKG_FILE="${UNPACKED}.tar.gz"
PKG_PATH="${PKG_DIR}/${PKG_FILE}"
PROFILE_FILE="profile_JDK.sh"

if [ ! -f $PKG_PATH ]; then
  echo "'$PKG_PATH' missing, downloading..."
  wget -O $PKG_PATH "https://www.kernel.org/pub/software/scm/git/${PKG_FILE}"
else
  echo "'$PKG_PATH' already exists, no need to download"
fi

echo "Installing $PKG_PATH..."
tar -xvf $PKG_PATH
mv ${UNPACKED} /opt

echo "Preparing to build Git..."
yum -y install curl-devel expat-devel fettext-devel openssl-devel perl-devel zlib-devel

echo "Building Git..."
cd /opt/${UNPACKED}
make configure
./configure --prefix=/usr
make
make install

echo "Configuring links..."
ln -snf /opt/${UNPACKED} /opt/git
ln -snf /opt/git/git /usr/bin/git

