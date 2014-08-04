#!/bin/bash

$NDK_HOME/ndk-build

if [ $? -eq 0 ] ; then
	cp -vf ffmpeg/android/arm/lib/libavcodec-55.so ../libs/armeabi
	cp -vf ffmpeg/android/arm/lib/libavfilter-4.so ../libs/armeabi
	cp -vf ffmpeg/android/arm/lib/libavformat-55.so ../libs/armeabi
	cp -vf ffmpeg/android/arm/lib/libavutil-52.so ../libs/armeabi
	cp -vf ffmpeg/android/arm/lib/libswresample-0.so ../libs/armeabi
	cp -vf ffmpeg/android/arm/lib/libswscale-2.so ../libs/armeabi
	echo "Build sucess =============>>>>> ^_^"
else
	echo "Build error =============>>>>> T_T"
fi