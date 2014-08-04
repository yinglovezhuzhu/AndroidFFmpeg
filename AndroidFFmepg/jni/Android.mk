LOCAL_PATH := $(call my-dir)  
  
include $(CLEAR_VARS)

PATH_TO_FFMPEG_SOURCE:=$(LOCAL_PATH)/ffmpeg

LOCAL_C_INCLUDES += $(PATH_TO_FFMPEG_SOURCE)

LOCAL_MODULE    := ffmpeg-jni

#LOCAL_SRC_FILES := ffmpeg-jni.c ffmpeg/cmdutils.h ffmpeg/cmdutils.c ffmpeg/ffmpeg.h ffmpeg/ffmpeg_opt.c ffmpeg/ffmpeg_filter.c  #必须把这几个文件编译进去，不然会很多undefinded的。。  
LOCAL_SRC_FILES := ffmpeg-jni.c ffmpegentry.c ffmpeg/cmdutils.c ffmpeg/ffmpeg_opt.c ffmpeg/ffmpeg_filter.c  #必须把这几个文件编译进去，不然会很多undefinded的。。  

#LOCAL_LDLIBS := -lffmpeg -llog -ljnigraphics -lz -ldl -lc -lgcc #这些就是所要关联的库了，刚才把ffmpeg.so复制到android-ndk-r8d/platforms/android-14/arch-arm/usr/lib目录下的原因就是为了这个  
#LOCAL_LDLIBS := -lavutil-52 -lavcodec-55 -lswresample-0 -lswscale-2 -lavformat-55 -lavfilter-3 -llog -ljnigraphics -lz -ldl -lc -lgcc #这些就是所要关联的库了，刚才把ffmpeg.so复制到android-ndk-r8d/platforms/android-14/arch-arm/usr/lib目录下的原因就是为了这个  
#avutil-52 avcodec-55 swresample-0 swscale-2 avformat-55 avfilter-3
#LOCAL_LDLIBS := $(LOCAL_PATH)/ffmpeg/android/arm/lib/libavutil-52.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libavcodec-55.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libswresample-0.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libswscale-2.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libavformat-55.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libavfilter-3.so \
	-llog -ljnigraphics -lz -ldl -lc -lgcc
LOCAL_LDLIBS := $(LOCAL_PATH)/ffmpeg/android/arm/lib/libavutil-52.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libavcodec-55.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libswresample-0.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libswscale-2.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libavformat-55.so \
	$(LOCAL_PATH)/ffmpeg/android/arm/lib/libavfilter-4.so \
	-llog -ljnigraphics -lz -ldl -lc -lgcc

include $(BUILD_SHARED_LIBRARY)