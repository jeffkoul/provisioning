#!/bin/bash

# downloads and installs JDK 8 on a Host machine

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

# !!! SPECIFY THE SPECIFIC VERSION OF JDK HERE !!!
MAJOR=8
MINOR=102


RPM_FILE="jdk-${MAJOR}u${MINOR}-linux-x64.rpm"
PROFILE_FILE="profile_JDK.sh"

if [ ! -f $RPM_FILE ]; then
  echo "'$RPM_FILE' missing, downloading..."
  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${MAJOR}u${MINOR}-b14/${RPM_FILE}"
else
  echo "'$RPM_FILE' already exists, no need to download"
fi

echo "Installing $RPM_FILE..."
cp $RPM_FILE /tmp
rpm -ivf /tmp/$RPM_FILE

DIR_LNK=/usr/bin
DIR_JDK="/usr/java/jdk1.${MAJOR}.0_${MINOR}"

echo "Registering this version of java with 'alternatives'..."
alternatives --install $DIR_LNK/java java $DIR_JDK/bin/java $MAJOR \
               --slave $DIR_LNK/javac javac $DIR_JDK/bin/javac \
               --slave $DIR_LNK/jar jar $DIR_JDK/bin/jar \
               --slave $DIR_LNK/jps jps $DIR_JDK/bin/jps \
               --slave $DIR_LNK/jdb jdb $DIR_JDK/bin/jdb \
               --slave $DIR_LNK/keytool keytool $DIR_JDK/bin/keytool \
               --slave $DIR_LNK/jarsigner jarsigner $DIR_JDK/bin/jarsigner \
               --slave $DIR_LNK/jcmd jcmd $DIR_JDK/bin/jcmd \
               --slave $DIR_LNK/jconsole jconsole $DIR_JDK/bin/jconsole \
               --slave $DIR_LNK/jmc jmc $DIR_JDK/bin/jmc \
               --slave $DIR_LNK/jvisualvm jvisualvm $DIR_JDK/bin/jvisualvm \
               --slave $DIR_LNK/jstat jstat $DIR_JDK/bin/jstat \
               --slave $DIR_LNK/jstatd jstatd $DIR_JDK/bin/jstatd \
               --slave $DIR_LNK/jmap jmap $DIR_JDK/bin/jmap \
               --slave $DIR_LNK/jstack jstack $DIR_JDK/bin/jstack \
               --slave /usr/java/latest java_latest $DIR_JDK

echo "Setting this version of java as active in  'alternatives'..."
alternatives --set java $DIR_JDK/bin/java

echo "Configuring profile..."
cp $SCRIPT_DIR/$PROFILE_FILE /tmp/$PROFILE_FILE
mv /tmp/$PROFILE_FILE /etc/profile.d/
chown root: /etc/profile.d/$PROFILE_FILE
chmod 644 /etc/profile.d/$PROFILE_FILE

