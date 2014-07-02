#!/bin/bash

export PROJECT_PATH=$(cd ../; pwd)

export SOURCE_PATH="${PROJECT_PATH}/app/src/main/java"

export CLASS_NAME="com.opensource.ffmpeg.android.test.MainActivity"

export TARGET_PATH="${PROJECT_PATH}/ffmpeg/src/main/jni"

rm -vf ${TARGET_PATH}/*Activity.h

javah -v -d ${TARGET_PATH} -classpath ${SOURCE_PATH} ${CLASS_NAME}