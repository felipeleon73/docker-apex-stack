#!/bin/bash

export APEX_HOME=$ORACLE_BASE/product/apex
export ORDS_HOME=$ORACLE_BASE/product/ords
export JAVA_HOME=$ORACLE_BASE/product/java/latest
export SCRIPT_DIR=$SCRIPTS_ROOT
export FILES_DIR=/tmp/files
export PATH=$JAVA_HOME/bin:$PATH

# Run ORDS
echo "##### Starting ORDS #####"
if [ $UID = "0" ]; then
  runuser oracle -m -s /bin/bash -c ". $SCRIPT_DIR/package/runOrds.sh"
else
  . $SCRIPT_DIR/package/runOrds.sh
fi