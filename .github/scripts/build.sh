#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

mkdir -p $BUILD_PATH
cd $BUILD_PATH
cmake -G "Unix Makefiles" $SOURCE_PATH/$AUDACITY_VERSION -DCMAKE_BUILD_TYPE=Release
make -j`sysctl -n hw.ncpu`
