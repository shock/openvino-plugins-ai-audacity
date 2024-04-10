#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

echo "BUILD_PATH=$BUILD_PATH"
echo "WORKSPACE_PATH=$WORKSPACE_PATH"
echo "SOURCE_PATH=$SOURCE_PATH"
echo "PACKAGE_PATH=$PACKAGE_PATH"
echo "ARTIFACT_PATH=$ARTIFACT_PATH"

which wget || brew install wget

brew list opencl-clhpp-headers || brew install opencl-clhpp-headers

cp -r $WORKSPACE_PATH/mod-openvino $SOURCE_PATH/$AUDACITY_VERSION/modules

grep -q "mod-openvino" $SOURCE_PATH/$AUDACITY_VERSION/modules/CMakeLists.txt
if [[ $? -ne 0 ]]; then
    sed -i '' 's/set( MODULES/set( MODULES\n   mod-openvino/' $SOURCE_PATH/$AUDACITY_VERSION/modules/CMakeLists.txt
fi

mkdir -p $PACKAGE_PATH
cd $PACKAGE_PATH


if [ ! -d "m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64" ]; then
    wget https://storage.openvinotoolkit.org/repositories/openvino/packages/2024.0/macos/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64.tgz
    tar xvf m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64.tgz
fi
source m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/setupvars.sh

if [ ! -d "$PACKAGE_PATH/libtorch" ]; then
    wget https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.2.2.zip
    unzip libtorch-macos-arm64-2.2.2.zip
fi

export LIBTORCH_ROOTDIR=$PACKAGE_PATH/libtorch

mkdir -p $BUILD_PATH/whisper
cd $BUILD_PATH/whisper
cmake $SOURCE_PATH/$WHISPER_VERSION -DWHISPER_OPENVINO=ON -DCMAKE_APPLE_SILICON_PROCESSOR=arm64 -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64
make -j`sysctl -n hw.ncpu`

export WHISPERCPP_ROOTDIR=$PACKAGE_PATH/whisper
cmake --install . --config Release --prefix $WHISPERCPP_ROOTDIR
export LD_LIBRARY_PATH=${WHISPERCPP_ROOTDIR}/lib:$LD_LIBRARY_PATH

mkdir -p $BUILD_PATH/audacity
cd $BUILD_PATH/audacity

AUDACITY_BUILD_TYPE=Release

cmake -G "Unix Makefiles" -DMACOS_ARCHITECTURE=arm64 \
    -D CMAKE_CXX_FLAGS="-I$HOMEBREW_PATH/opt/opencl-clhpp-headers/include" \
     $SOURCE_PATH/$AUDACITY_VERSION -DCMAKE_BUILD_TYPE=$AUDACITY_BUILD_TYPE
make -j`sysctl -n hw.ncpu`

find $AUDACITY_BUILD_TYPE

AUDACITY_APP_PATH=$BUILD_PATH/audacity/$AUDACITY_BUILD_TYPE/Audacity.app
cp $WHISPERCPP_ROOTDIR/lib/libwhisper.dylib $AUDACITY_APP_PATH/Contents/Frameworks
cp $LIBTORCH_ROOTDIR/lib/libc10.dylib $AUDACITY_APP_PATH/Contents/Frameworks
cp $LIBTORCH_ROOTDIR/lib/libtorch.dylib $AUDACITY_APP_PATH/Contents/Frameworks
cp $LIBTORCH_ROOTDIR/lib/libtorch_cpu.dylib $AUDACITY_APP_PATH/Contents/Frameworks
cp $PACKAGE_PATH/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/runtime/lib/arm64/Release/*.so \
    $AUDACITY_APP_PATH/Contents/Frameworks
cp $PACKAGE_PATH/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/runtime/lib/arm64/Release/*.dylib \
    $AUDACITY_APP_PATH/Contents/Frameworks
mkdir -p $AUDACITY_APP_PATH/../3rdparty/tbb
cp $PACKAGE_PATH/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/runtime/3rdparty/tbb/lib/libtbb.12.dylib \
    $AUDACITY_APP_PATH/../3rdparty/tbb

mkdir -p $ARTIFACT_PATH/$PACKAGE_NAME/Contents/modules
mkdir -p $ARTIFACT_PATH/$PACKAGE_NAME/Contents/Frameworks

cp $AUDACITY_APP_PATH/Contents/modules/mod-openvino.so \
    $ARTIFACT_PATH/$PACKAGE_NAME/Contents/modules
cp $PACKAGE_PATH/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/runtime/lib/arm64/Release/*.so \
    $ARTIFACT_PATH/$PACKAGE_NAME/Contents/Frameworks
cp $PACKAGE_PATH/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/runtime/lib/arm64/Release/*.dylib \
    $ARTIFACT_PATH/$PACKAGE_NAME/Contents/Frameworks
cp $PACKAGE_PATH/m_openvino_toolkit_macos_11_0_2024.0.0.14509.34caeefd078_arm64/runtime/3rdparty/tbb/lib/libtbb.12.dylib \
    $ARTIFACT_PATH/$PACKAGE_NAME/Contents/Frameworks
