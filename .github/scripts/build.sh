#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

mkdir -p $BUILD_PATH
cd $BUILD_PATH

cp -r $WORKSPACE_PATH/mod-openvino $SOURCE_PATH/$AUDACITY_VERSION/modules
sed -i '' 's/set( MODULES/set( MODULES\n   mod-openvino/' $SOURCE_PATH/$AUDACITY_VERSION/modules/CMakeLists.txt

cmake -G "Unix Makefiles" $SOURCE_PATH/$AUDACITY_VERSION -DCMAKE_BUILD_TYPE=Release
make -j`sysctl -n hw.ncpu`

find Release
