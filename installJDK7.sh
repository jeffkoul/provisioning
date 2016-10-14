#!/bin/bash

# downloads and installs JDK 7 on a Host machine

get_script_dir () {

    # If no symlinks are in play, the following is adaquate:
    # DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}

SCRIPT_DIR=`get_script_dir`

RPM_FILE="jdk-7u80-linux-x64.rpm"
PROFILE_FILE="profile_JDK.sh"

if [ ! -f $RPM_FILE ]; then
  echo "'$RPM_FILE' missing, downloading..."
  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u80-b14/$RPM_FILE"
else
  echo "'$RPM_FILE' already exists, no need to download"
fi

echo "Installing $RPM_FILE..."
cp $RPM_FILE /tmp
rpm -ivf /tmp/$RPM_FILE

echo "Registering this version of java with 'alternatives'..."
alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_80/bin/java 7
alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_80/bin/javac 7
alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_80/bin/jar 7
alternatives --install /usr/bin/jps jps /usr/java/jdk1.7.0_80/bin/jps 7
alternatives --install /usr/java/latest java_latest /usr/java/jdk1.7.0_80 7

echo "Setting this version of java as active in  'alternatives'..."
alternatives --set java /usr/java/jdk1.7.0_80/bin/java
alternatives --set javac /usr/java/jdk1.7.0_80/bin/javac
alternatives --set jar /usr/java/jdk1.7.0_80/bin/jar
alternatives --set jps /usr/java/jdk1.7.0_80/bin/jps
alternatives --set java_latest /usr/java/jdk1.7.0_80

echo "Configuring profile..."
cp $SCRIPT_DIR/$PROFILE_FILE /tmp/$PROFILE_FILE
mv /tmp/$PROFILE_FILE /etc/profile.d/
chown root: /etc/profile.d/$PROFILE_FILE
chmod 644 /etc/profile.d/$PROFILE_FILE

