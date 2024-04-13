#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

echo "BUILD_PATH=$BUILD_PATH"
echo "WORKSPACE_PATH=$WORKSPACE_PATH"
echo "SOURCE_PATH=$SOURCE_PATH"
echo "PACKAGE_PATH=$PACKAGE_PATH"

echo "Deleting $BUILD_PATH"
read -p "Are you sure you want to proceed? (y/n) " confirm
if [[ $confirm == "y" || $confirm == "Y" ]]; then
    rm -rf $BUILD_PATH
    echo "$BUILD_PATH deleted"
else
    echo "Leaving $BUILD_PATH"
fi

echo "Deleting $PACKAGE_PATH"
read -p "Are you sure you want to proceed? (y/n) " confirm
if [[ $confirm == "y" || $confirm == "Y" ]]; then
    rm -rf $PACKAGE_PATH
    echo "$PACKAGE_PATH deleted"
else
    echo "Leaving $PACKAGE_PATH"
fi
