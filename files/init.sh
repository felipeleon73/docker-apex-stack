#!/bin/bash

export APEX_HOME=$ORACLE_BASE/product/apex
export ORDS_HOME=$ORACLE_BASE/product/ords
export JAVA_HOME=$ORACLE_BASE/product/java/latest
export FILES_DIR=/tmp/files
export PATH=$JAVA_HOME/bin:$PATH
export INSTALL_FILE_APEX=apex_20.2.zip
export INSTALL_FILE_ORDS=ords-20.2.1.227.0350.zip
export INSTALL_FILE_JAVA=jdk-8u271-linux-x64.tar.gz

echo "APEX_HOME: $APEX_HOME"
echo "ORDS_HOME: $ORDS_HOME"
echo "JAVA_HOME: $JAVA_HOME"
echo "FILES_DIR: $FILES_DIR"
echo "PATH: $PATH"

if [ ! -d $JAVA_HOME ]; then
  JAVA_DIR_NAME=`tar -tzf $FILES_DIR/$INSTALL_FILE_JAVA | head -1 | cut -f1 -d"/"`
  mkdir -p $ORACLE_BASE/product/java
  tar zxf $FILES_DIR/$INSTALL_FILE_JAVA --directory $ORACLE_BASE/product/java
  ln -s $ORACLE_BASE/product/java/$JAVA_DIR_NAME $JAVA_HOME
fi

# Extract files
echo "##### Extracting files ####"
mkdir -p $ORDS_HOME
unzip -q $FILES_DIR/$INSTALL_FILE_APEX -d $ORACLE_BASE/product
unzip -q $FILES_DIR/$INSTALL_FILE_ORDS -d $ORDS_HOME
chown -R oracle:oinstall $APEX_HOME $ORDS_HOME

rm -r /tmp/files
