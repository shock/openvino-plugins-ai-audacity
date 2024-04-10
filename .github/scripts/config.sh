#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail if any command in pipeline is an error

HOMEBREW_PATH=$(dirname $(dirname $(which brew)))
BUILD_PATH=${BUILD_PATH:-$PWD/build}
WORKSPACE_PATH=$(pwd)
SOURCE_PATH=$WORKSPACE_PATH/code
PACKAGE_PATH=$WORKSPACE_PATH/package
ARTIFACT_PATH=$WORKSPACE_PATH/artifact

AUDACITY_REPO=audacity/audacity
AUDACITY_BRANCH=Audacity-3.4.2
AUDACITY_VERSION=audacity-3.4.2

WHISPER_REPO=ggerganov/whisper.cpp
WHISPER_BRANCH=v1.5.4
WHISPER_VERSION=whisper-1.5.4

PACKAGE_NAME=Audacity-OpenVINO-Module-macos-arm64-3.4.2-R1

ARTIFACT_PATH=$WORKSPACE_PATH/artifact
PACKAGE_PATH=$WORKSPACE_PATH/package
SOURCE_PATH=$WORKSPACE_PATH/code
