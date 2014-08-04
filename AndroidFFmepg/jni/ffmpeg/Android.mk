# FFmpeg for Android
# http://sourceforge.net/projects/ffmpeg4android/
# Srdjan Obucina <obucinac@gmail.com>

LOCAL_PATH:=$(call my-dir)

FFMPEG_ROOT_DIR := $(LOCAL_PATH)
FFMPEG_CONFIG_DIR := android/$(TARGET_PRODUCT)-$(TARGET_BUILD_VARIANT)

VERSION_SUFFIX := -$(shell (cat $(FFMPEG_ROOT_DIR)/RELEASE))
$(warning $(VERSION_SUFFIX))

ifeq ($(findstring 2.2, $(VERSION_SUFFIX)),2.2)
    VERSION_BRANCH := 2.2
else ifeq ($(findstring 2.1, $(VERSION_SUFFIX)),2.1)
    VERSION_BRANCH := 2.1
#else ifeq ($(findstring 2.0, $(VERSION_SUFFIX)),2.0)
#    VERSION_BRANCH := 2.0
#else ifeq ($(findstring 1.2, $(VERSION_SUFFIX)),1.2)
#    VERSION_BRANCH := 1.2
#else ifeq ($(findstring 1.1, $(VERSION_SUFFIX)),1.1)
#    VERSION_BRANCH := 1.1
#else ifeq ($(findstring 1.0, $(VERSION_SUFFIX)),1.0)
#    VERSION_BRANCH := 1.0
#else ifeq ($(findstring 0.11, $(VERSION_SUFFIX)),0.11)
#    VERSION_BRANCH := 0.11
#else ifeq ($(findstring 0.10, $(VERSION_SUFFIX)),0.10)
#    VERSION_BRANCH := 0.10
#else ifeq ($(findstring 0.9, $(VERSION_SUFFIX)),0.9)
#    VERSION_BRANCH := 0.9
#else ifeq ($(findstring 0.8, $(VERSION_SUFFIX)),0.8)
#    VERSION_BRANCH := 0.8
else ifeq ($(findstring 0.7, $(VERSION_SUFFIX)),0.7)
    VERSION_BRANCH := 0.7
endif

ifeq ($(VERSION_BRANCH),)
    $(error Unsupported FFmpeg version)
endif

include $(CLEAR_VARS)

include $(FFMPEG_ROOT_DIR)/Android_configure.mk

include $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/config.mak

TOOLS_LIBRARIES :=

#============================== libavdevice =============================
ifeq ($(CONFIG_AVDEVICE),yes)
    FFMPEG_LIB_DIR := libavdevice
    TOOLS_LIBRARIES += libavdevice$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libavdevice.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libavfilter =============================
ifeq ($(CONFIG_AVFILTER),yes)
    FFMPEG_LIB_DIR := libavfilter
    TOOLS_LIBRARIES += libavfilter$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libavfilter.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libavformat =============================
ifeq ($(CONFIG_AVFORMAT),yes)
    FFMPEG_LIB_DIR := libavformat
    TOOLS_LIBRARIES += libavformat$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR) \
            external/zlib
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libavformat.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS) \
            libz
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR) \
            external/zlib
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS) \
            libz
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libavcodec ==============================
ifeq ($(CONFIG_AVCODEC),yes)
    FFMPEG_LIB_DIR := libavcodec
    TOOLS_LIBRARIES += libavcodec$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR) \
            external/zlib
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libavcodec.ver
        ifeq ($(TARGET_ARCH),arm)
            LOCAL_LDFLAGS += \
                -Wl,--no-warn-shared-textrel
        endif
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS) \
            libz
        LOCAL_ARM_MODE := arm
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR) \
            external/zlib
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS) \
            libz
        LOCAL_ARM_MODE := arm
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libavresample ===========================
ifeq ($(CONFIG_AVRESAMPLE),yes)
    FFMPEG_LIB_DIR := libavresample
    TOOLS_LIBRARIES += libavresample$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libavresample.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libpostproc =============================
ifeq ($(CONFIG_POSTPROC),yes)
    FFMPEG_LIB_DIR := libpostproc
    TOOLS_LIBRARIES += libpostproc$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libpostproc.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libswresample ===========================
ifeq ($(CONFIG_SWRESAMPLE),yes)
    FFMPEG_LIB_DIR := libswresample
    TOOLS_LIBRARIES += libswresample$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libswresample.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libswscale ==============================
ifeq ($(CONFIG_SWSCALE),yes)
    FFMPEG_LIB_DIR := libswscale
    TOOLS_LIBRARIES += libswscale$(VERSION_SUFFIX)
    include $(CLEAR_VARS)
    include $(FFMPEG_ROOT_DIR)/Android_.mk
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_LDFLAGS += \
            -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libswscale.ver
        LOCAL_SHARED_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_SHARED_LIBRARY)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            $(FFFILES)
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
            $(FFMPEG_ROOT_DIR)
        LOCAL_CFLAGS += \
            $(FFCFLAGS)
        LOCAL_LDFLAGS += \
            $(arch_variant_ldflags)
        LOCAL_STATIC_LIBRARIES := \
            $(FFLIBS)
        LOCAL_MODULE_TAGS := optional
        LOCAL_PRELINK_MODULE := false
        LOCAL_MODULE := $(FFNAME)
        include $(BUILD_STATIC_LIBRARY)
    endif
endif
#========================================================================

#============================== libavutil ===============================
FFMPEG_LIB_DIR := libavutil
TOOLS_LIBRARIES += libavutil$(VERSION_SUFFIX)
include $(CLEAR_VARS)
include $(FFMPEG_ROOT_DIR)/Android_.mk
ifeq ($(CONFIG_SHARED),yes)
    include $(CLEAR_VARS)
    LOCAL_SRC_FILES := \
        $(FFFILES)
    LOCAL_C_INCLUDES := \
        $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
        $(FFMPEG_ROOT_DIR)
    LOCAL_CFLAGS += \
        $(FFCFLAGS)
    LOCAL_LDFLAGS += \
        $(arch_variant_ldflags)
    LOCAL_LDFLAGS += \
        -Wl,--version-script,$(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/$(FFMPEG_LIB_DIR)/libavutil.ver
    LOCAL_SHARED_LIBRARIES := \
        $(FFLIBS)
    LOCAL_MODULE_TAGS := optional
    LOCAL_PRELINK_MODULE := false
    LOCAL_MODULE := $(FFNAME)
		
    include $(BUILD_SHARED_LIBRARY)
endif
ifeq ($(CONFIG_STATIC),yes)
    include $(CLEAR_VARS)
    LOCAL_SRC_FILES := \
        $(FFFILES)
    LOCAL_C_INCLUDES := \
        $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR) \
        $(FFMPEG_ROOT_DIR)
    LOCAL_CFLAGS += \
        $(FFCFLAGS)
    LOCAL_LDFLAGS += \
        $(arch_variant_ldflags)
    LOCAL_STATIC_LIBRARIES := \
        $(FFLIBS)
    LOCAL_MODULE_TAGS := optional
    LOCAL_PRELINK_MODULE := false
    LOCAL_MODULE := $(FFNAME)
		
    include $(BUILD_STATIC_LIBRARY)
endif
#========================================================================

#============================== avconv ==================================
ifeq ($(CONFIG_AVCONV),yes)
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            avconv.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := avconv$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            avconv.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_STATIC_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := avconv-static$(VERSION_SUFFIX)
        
		
		
        include $(BUILD_EXECUTABLE)
    endif
endif
#========================================================================

#============================== ffplay ==================================
ifeq ($(CONFIG_FFPLAY),yes)
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffplay.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffplay$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffplay.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_STATIC_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffplay-static$(VERSION_SUFFIX)
        
		
		
        include $(BUILD_EXECUTABLE)
    endif
endif
#========================================================================

#============================== ffmpeg ==================================
ifeq ($(CONFIG_FFMPEG),yes)
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffmpeg.c
        ifeq ($(VERSION_BRANCH),2.2)
            LOCAL_SRC_FILES +=  \
                ffmpeg_filter.c \
                ffmpeg_opt.c
        endif
        ifeq ($(VERSION_BRANCH),2.1)
            LOCAL_SRC_FILES +=  \
                ffmpeg_filter.c \
                ffmpeg_opt.c
        endif
#        ifeq ($(VERSION_BRANCH),2.0)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
#        ifeq ($(VERSION_BRANCH),1.2)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
#        ifeq ($(VERSION_BRANCH),1.1)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
#        ifeq ($(VERSION_BRANCH),1.0)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffmpeg$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffmpeg.c
        ifeq ($(VERSION_BRANCH),2.2)
            LOCAL_SRC_FILES +=  \
                ffmpeg_filter.c \
                ffmpeg_opt.c
        endif
        ifeq ($(VERSION_BRANCH),2.1)
            LOCAL_SRC_FILES +=  \
                ffmpeg_filter.c \
                ffmpeg_opt.c
        endif
#        ifeq ($(VERSION_BRANCH),2.0)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
#        ifeq ($(VERSION_BRANCH),1.2)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
#        ifeq ($(VERSION_BRANCH),1.1)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
#        ifeq ($(VERSION_BRANCH),1.0)
#            LOCAL_SRC_FILES +=  \
#                ffmpeg_filter.c \
#                ffmpeg_opt.c
#        endif
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            libz
        LOCAL_STATIC_LIBRARIES := \
            $(TOOLS_LIBRARIES)
		LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffmpeg-static$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
endif
#========================================================================

#============================== ffprobe =================================
ifeq ($(CONFIG_FFPROBE),yes)
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffprobe.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffprobe$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffprobe.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            libz
        LOCAL_STATIC_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffprobe-static$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
endif
#========================================================================

#============================== ffserver ================================
ifeq ($(CONFIG_FFSERVER),yes)
    ifeq ($(CONFIG_SHARED),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffserver.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_SHARED_LIBRARIES += \
            libdl \
            libz
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffserver$(VERSION_SUFFIX)
        
		
		
        include $(BUILD_EXECUTABLE)
    endif
    ifeq ($(CONFIG_STATIC),yes)
        include $(CLEAR_VARS)
        LOCAL_SRC_FILES := \
            cmdutils.c \
            ffserver.c
        LOCAL_C_INCLUDES := \
            $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)
        LOCAL_SHARED_LIBRARIES := \
            libdl \
            libz
        LOCAL_STATIC_LIBRARIES := \
            $(TOOLS_LIBRARIES)
        LOCAL_MODULE_TAGS := optional
        LOCAL_MODULE := ffserver-static$(VERSION_SUFFIX)
        include $(BUILD_EXECUTABLE)
    endif
endif
#========================================================================
