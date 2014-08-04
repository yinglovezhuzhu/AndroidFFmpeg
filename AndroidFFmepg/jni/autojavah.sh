#/bin/bash

export PROJECT_PATH=$(cd ../; pwd)

export CLASS_NAME="com.opensource.androidffmpeg.utils.FFmpegTool"
#export CLASS_NAME="com.opensource.androidffmpeg.MainActivity"

export CLASS_PATH="${PROJECT_PATH}/src"

export TARGET_PATH="${PROJECT_PATH}/jni"

rm -vf ${TARGET_PATH}/FFmpegTool.h

javah -d ${TARGET_PATH} -classpath ${CLASS_PATH} ${CLASS_NAME}
