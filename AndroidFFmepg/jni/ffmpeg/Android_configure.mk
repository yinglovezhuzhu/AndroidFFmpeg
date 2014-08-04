# FFmpeg for Android
# http://sourceforge.net/projects/ffmpeg4android/
# Srdjan Obucina <obucinac@gmail.com>

LOCAL_PATH:=$(call my-dir)

include $(CLEAR_VARS)



# Use $(ANDROID_TOOLCHAIN) for library configuration
NDK_CROSS_PREFIX := $(subst -gcc,-,$(shell (ls $(ANDROID_TOOLCHAIN)/*gcc)))

# Always select highest NDK and SDK version
NDK_SYSROOT := $(ANDROID_BUILD_TOP)/$(shell (ls -dv prebuil*/ndk/android-ndk-r*/platforms/android-*/arch-$(TARGET_ARCH) | tail -1))

# Fix for latest master branch
ifeq ($(NDK_SYSROOT),$(ANDROID_BUILD_TOP)/)
    NDK_SYSROOT := $(ANDROID_BUILD_TOP)/$(shell (ls -dv prebuil*/ndk/current/platforms/android-*/arch-$(TARGET_ARCH) | tail -1))
endif



FF_CONFIGURATION_STRING := \
    --arch=$(TARGET_ARCH) \
    --target-os=linux \
    --enable-cross-compile \
    --cross-prefix=$(NDK_CROSS_PREFIX) \
    --sysroot=$(NDK_SYSROOT) \
    --enable-shared \
    --enable-static \

ifeq ($(VERSION_BRANCH),2.2)
    FF_CONFIGURATION_STRING += \
        --enable-avresample
endif

ifeq ($(VERSION_BRANCH),2.1)
    FF_CONFIGURATION_STRING += \
        --enable-avresample
endif

#ifeq ($(VERSION_BRANCH),2.0)
#    FF_CONFIGURATION_STRING += \
#        --enable-avresample
#endif

#ifeq ($(VERSION_BRANCH),1.2)
#    FF_CONFIGURATION_STRING += \
#        --enable-avresample
#endif

#ifeq ($(VERSION_BRANCH),1.1)
#    FF_CONFIGURATION_STRING += \
#        --enable-avresample
#endif

#ifeq ($(VERSION_BRANCH),1.0)
#    FF_CONFIGURATION_STRING += \
#        --enable-avresample
#endif

#ifeq ($(VERSION_BRANCH),0.11)
#    FF_CONFIGURATION_STRING += \
#        --enable-avresample
#endif

ifeq ($(VERSION_BRANCH),0.7)
    FF_CONFIGURATION_STRING += \
        --disable-ffplay \
        --disable-indev=v4l
endif

# Temporary, until bug is fixed
ifeq ($(TARGET_ARCH),x86)
    FF_DISABLE_MMX := --disable-mmx
    FF_DISABLE_MMX2 := --disable-mmx2
    ifeq ($(VERSION_BRANCH),2.2)
        FF_DISABLE_MMX2 := --disable-mmxext
    endif
    ifeq ($(VERSION_BRANCH),2.1)
        FF_DISABLE_MMX2 := --disable-mmxext
    endif
#    ifeq ($(VERSION_BRANCH),2.0)
#        FF_DISABLE_MMX2 := --disable-mmxext
#    endif
#    ifeq ($(VERSION_BRANCH),1.2)
#        FF_DISABLE_MMX2 := --disable-mmxext
#    endif
#    ifeq ($(VERSION_BRANCH),1.1)
#        FF_DISABLE_MMX2 := --disable-mmxext
#    endif
#    ifeq ($(VERSION_BRANCH),1.0)
#        FF_DISABLE_MMX2 := --disable-mmxext
#    endif
    FF_CONFIGURATION_STRING += $(FF_DISABLE_MMX) $(FF_DISABLE_MMX2) 
endif

include $(ANDROID_BUILD_TOP)/build/core/combo/arch/$(TARGET_ARCH)/$(TARGET_ARCH_VARIANT).mk

ifeq ($(TARGET_ARCH),arm)
    FF_CONFIGURATION_STRING += --extra-cflags='$(arch_variant_cflags)'
    FF_CONFIGURATION_STRING += --extra-ldflags='$(arch_variant_ldflags)'
endif



# Do not edit after this line
#===============================================================================

FF_LAST_CONFIGURATION_STRING_COMMAND := \
    cat $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/LAST_CONFIGURATION_STRING;
FF_LAST_CONFIGURATION_STRING_OUTPUT := $(shell $(FF_LAST_CONFIGURATION_STRING_COMMAND))

#===============================================================================
ifneq ($(FF_CONFIGURATION_STRING), $(FF_LAST_CONFIGURATION_STRING_OUTPUT))

    FF_CREATE_CONFIG_DIR_COMMAND := \
        cd $(FFMPEG_ROOT_DIR); \
        rm -rf $(FFMPEG_CONFIG_DIR); \
        mkdir -p $(FFMPEG_CONFIG_DIR); \
        cd $$OLDPWD;

    $(warning ============================================================)
    $(warning Creating configuration directory...)
    $(warning $(FF_CREATE_CONFIG_DIR_COMMAND))
    FF_CREATE_CONFIG_DIR_OUTPUT := $(shell $(FF_CREATE_CONFIG_DIR_COMMAND))
    $(warning Done.)
    $(warning ============================================================)



    FF_CREATE_REQUIRED_FILES_COMMAND := \
        cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
        ../../configure \
    --arch=$(TARGET_ARCH) \
    --target-os=linux \
    --enable-cross-compile \
    --cross-prefix=$(NDK_CROSS_PREFIX) \
    --sysroot=$(NDK_SYSROOT) \
            --enable-shared \
            --enable-static \
            --enable-gpl \
            --disable-everything \
            --disable-yasm; \
        make -j; \
        find | grep -v "\.ver" | grep -v "ffversion\.h" | grep -v "version\.h" | xargs rm; \
        cd $$OLDPWD;

    ifeq ($(VERSION_BRANCH),2.2)
        FF_CREATE_REQUIRED_FILES_COMMAND := \
            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
            ../../configure \
    --arch=$(TARGET_ARCH) \
    --target-os=linux \
    --enable-cross-compile \
    --cross-prefix=$(NDK_CROSS_PREFIX) \
    --sysroot=$(NDK_SYSROOT) \
                --enable-shared \
                --enable-static \
                --enable-gpl \
                --enable-avresample \
                --disable-everything \
                --disable-yasm; \
            make -j; \
            find | grep -v "\.ver" | grep -v "ffversion\.h" | grep -v "version\.h" | xargs rm; \
            cd $$OLDPWD;
    endif

    ifeq ($(VERSION_BRANCH),2.1)
        FF_CREATE_REQUIRED_FILES_COMMAND := \
            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
            ../../configure \
    --arch=$(TARGET_ARCH) \
    --target-os=linux \
    --enable-cross-compile \
    --cross-prefix=$(NDK_CROSS_PREFIX) \
    --sysroot=$(NDK_SYSROOT) \
                --enable-shared \
                --enable-static \
                --enable-gpl \
                --enable-avresample \
                --disable-everything \
                --disable-yasm; \
            make -j; \
            find | grep -v "\.ver" | grep -v "ffversion\.h" | grep -v "version\.h" | xargs rm; \
            cd $$OLDPWD;
    endif

#    ifeq ($(VERSION_BRANCH),2.0)
#        FF_CREATE_REQUIRED_FILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            ../../configure \
#                --enable-shared \
#                --enable-static \
#                --enable-gpl \
#                --enable-avresample \
#                --disable-everything \
#                --disable-yasm; \
#            make -j; \
#            cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),1.2)
#        FF_CREATE_REQUIRED_FILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            ../../configure \
#                --enable-shared \
#                --enable-static \
#                --enable-gpl \
#                --enable-avresample \
#                --disable-everything \
#                --disable-yasm; \
#            make -j; \
#            find | grep -v "\.ver" | grep -v "ffversion\.h" | grep -v "version\.h" | xargs rm; \
#            cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),1.1)
#        FF_CREATE_REQUIRED_FILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            ../../configure \
#                --enable-shared \
#                --enable-static \
#                --enable-gpl \
#                --enable-avresample \
#                --disable-everything \
#                --disable-yasm; \
#            make -j; \
#            cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),1.0)
#        FF_CREATE_REQUIRED_FILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            ../../configure \
#                --enable-shared \
#                --enable-static \
#                --enable-gpl \
#                --enable-avresample \
#                --disable-everything \
#                --disable-yasm; \
#            make -j; \
#            cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),0.11)
#        FF_CREATE_REQUIRED_FILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            ../../configure \
#                --enable-shared \
#                --enable-static \
#                --enable-gpl \
#                --enable-avresample \
#                --disable-everything \
#                --disable-yasm; \
#            make -j; \
#            cd $$OLDPWD;
#    endif

    $(warning ============================================================)
    $(warning Creating required files...)
    $(warning $(FF_CREATE_REQUIRED_FILES_COMMAND))
    FF_CREATE_REQUIRED_FILES_OUTPUT := $(shell $(FF_CREATE_REQUIRED_FILES_COMMAND))
    $(warning Done.)
    $(warning ============================================================)



    FF_CONFIGURATION_COMMAND := \
        cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
        ../../configure $(FF_CONFIGURATION_STRING); \
        cd $$OLDPWD;

    $(warning ============================================================)
    $(warning Configuring FFmpeg...)
    $(warning $(FF_CONFIGURATION_COMMAND))
    FF_CONFIGURATION_OUTPUT := $(shell $(FF_CONFIGURATION_COMMAND))
    $(warning Done.)
    $(warning ============================================================)



    ifeq ($(VERSION_BRANCH),2.2)
        FF_FIX_CONFIGURATION_COMMAND := \
            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
            \
            cat config.h | \
            sed 's/\#define av_restrict /\#ifdef av_restrict\n\#undef av_restrict\n\#endif\n\#define av_restrict /g' | \
            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
            sed 's/\#define HAVE_SYSCTL 1/\#define HAVE_SYSCTL 0/g' | \
            cat > config.h.tmp; \
            mv config.h config.h.bak; \
            mv config.h.tmp config.h; \
            \
            cat config.mak | \
            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
            sed 's/HAVE_SYSCTL=yes/!HAVE_SYSCTL=yes/g' | \
            cat > config.mak.tmp; \
            mv config.mak config.mak.bak; \
            mv config.mak.tmp config.mak; \
            \
            cd $(OLDPWD);
    endif

    ifeq ($(VERSION_BRANCH),2.1)
        FF_FIX_CONFIGURATION_COMMAND := \
            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
            \
            cat config.h | \
            sed 's/\#define av_restrict /\#ifdef av_restrict\n\#undef av_restrict\n\#endif\n\#define av_restrict /g' | \
            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
            sed 's/\#define HAVE_SYSCTL 1/\#define HAVE_SYSCTL 0/g' | \
            cat > config.h.tmp; \
            mv config.h config.h.bak; \
            mv config.h.tmp config.h; \
            \
            cat config.mak | \
            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
            sed 's/HAVE_SYSCTL=yes/!HAVE_SYSCTL=yes/g' | \
            cat > config.mak.tmp; \
            mv config.mak config.mak.bak; \
            mv config.mak.tmp config.mak; \
            \
            cd $(OLDPWD);
    endif

#    ifeq ($(VERSION_BRANCH),2.0)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define av_restrict restrict/\#define av_restrict __restrict/g' | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),1.2)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define av_restrict /\#ifdef av_restrict\n\#undef av_restrict\n\#endif\n\#define av_restrict /g' | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            sed 's/\#define HAVE_SYSCTL 1/\#define HAVE_SYSCTL 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            sed 's/HAVE_SYSCTL=yes/!HAVE_SYSCTL=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),1.1)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define av_restrict restrict/\#define av_restrict __restrict/g' | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),1.0)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),0.11)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),0.10)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),0.9)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

#    ifeq ($(VERSION_BRANCH),0.8)
#        FF_FIX_CONFIGURATION_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
#            \
#            cat config.h | \
#            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
#            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
#            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
#            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
#            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
#            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
#            cat > config.h.tmp; \
#            mv config.h config.h.bak; \
#            mv config.h.tmp config.h; \
#            \
#            cat config.mak | \
#            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
#            cat > config.mak.tmp; \
#            mv config.mak config.mak.bak; \
#            mv config.mak.tmp config.mak; \
#            \
#            cd $(OLDPWD);
#    endif

    ifeq ($(VERSION_BRANCH),0.7)
        FF_FIX_CONFIGURATION_COMMAND := \
            cd $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR); \
            \
            cat config.h | \
            sed 's/\#define restrict restrict/\#define restrict __restrict/g' | \
            sed 's/\#define ARCH_ARM /\#ifdef ARCH_ARM\n\#undef ARCH_ARM\n\#endif\n\#define ARCH_ARM /g' | \
            sed 's/\#define ARCH_MIPS /\#ifdef ARCH_MIPS\n\#undef ARCH_MIPS\n\#endif\n\#define ARCH_MIPS /g' | \
            sed 's/\#define ARCH_X86 /\#ifdef ARCH_X86\n\#undef ARCH_X86\n\#endif\n\#define ARCH_X86 /g' | \
            sed 's/\#define HAVE_PTHREADS/\#ifdef HAVE_PTHREADS\n\#undef HAVE_PTHREADS\n\#endif\n\#define HAVE_PTHREADS/g' | \
            sed 's/\#define HAVE_MALLOC_H/\#ifdef HAVE_MALLOC_H\n\#undef HAVE_MALLOC_H\n\#endif\n\#define HAVE_MALLOC_H/g' | \
            sed 's/\#define HAVE_STRERROR_R 1/\#define HAVE_STRERROR_R 0/g' | \
            sed 's/\#define HAVE_SYSCTL 1/\#define HAVE_SYSCTL 0/g' | \
            cat > config.h.tmp; \
            mv config.h config.h.bak; \
            mv config.h.tmp config.h; \
            \
            cat config.mak | \
            sed 's/HAVE_STRERROR_R=yes/!HAVE_STRERROR_R=yes/g' | \
            sed 's/HAVE_SYSCTL=yes/!HAVE_SYSCTL=yes/g' | \
            cat > config.mak.tmp; \
            mv config.mak config.mak.bak; \
            mv config.mak.tmp config.mak; \
            \
            cd $(OLDPWD);
    endif

    $(warning ============================================================)
    $(warning Fixing configuration...)
    #$(warning $(FF_FIX_CONFIGURATION_COMMAND))
    FF_FIX_CONFIGURATION_OUTPUT := $(shell $(FF_FIX_CONFIGURATION_COMMAND))
    $(warning Done.)
    $(warning ============================================================)



    ifeq ($(VERSION_BRANCH),2.2)
        FF_FIX_MAKEFILES_COMMAND := \
            cd $(FFMPEG_ROOT_DIR); \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
                sed 's/clean::/\#clean::/g'                                                                           | \
                sed 's/\t$$(RM) $$(CLEANSUFFIXES/\#\t$$(RM) $$(CLEANSUFFIXES/g'                                       > libavfilter/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
                cd $$OLDPWD;
    endif

    ifeq ($(VERSION_BRANCH),2.1)
        FF_FIX_MAKEFILES_COMMAND := \
            cd $(FFMPEG_ROOT_DIR); \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
                sed 's/clean::/\#clean::/g'                                                                           | \
                sed 's/\t$$(RM) $$(CLEANSUFFIXES/\#\t$$(RM) $$(CLEANSUFFIXES/g'                                       > libavfilter/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
                cd $$OLDPWD;
    endif

#    ifeq ($(VERSION_BRANCH),2.0)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
#                sed 's/clean::/\#clean::/g'                                                                           | \
#                sed 's/\t$$(RM) $$(CLEANSUFFIXES/\#\t$$(RM) $$(CLEANSUFFIXES/g'                                       > libavfilter/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
#                cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),1.2)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
#                sed 's/clean::/\#clean::/g'                                                                           | \
#                sed 's/\t$$(RM) $$(CLEANSUFFIXES/\#\t$$(RM) $$(CLEANSUFFIXES/g'                                       > libavfilter/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
#                cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),1.1)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
#                sed 's/clean::/\#clean::/g'                                                                           | \
#                sed 's/\t$$(RM) $$(CLEANSUFFIXES/\#\t$$(RM) $$(CLEANSUFFIXES/g'                                       > libavfilter/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
#                cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),1.0)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
#                sed 's/clean::/\#clean::/g'                                                                           | \
#                sed 's/\t$$(RM) $$(CLEANSUFFIXES/\#\t$$(RM) $$(CLEANSUFFIXES/g'                                       > libavfilter/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
#                cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),0.11)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    > libavfilter/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavresample/Makefile  > libavresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
#                sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
#                cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),0.10)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     > libavcodec/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    > libavdevice/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    > libavfilter/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    > libavformat/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      > libavutil/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    > libpostproc/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  > libswresample/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     > libswscale/Makefile.android; \
#            cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),0.9)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         | \
#            sed 's/-include $$(SRC_PATH)\/$$(SUBDIR)$$(ARCH)\/Makefile/include $$(LOCAL_PATH)\/libavcodec\/$$(ARCH)\/Makefile/g' > libavcodec/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libavdevice/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libavfilter/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libavformat/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libavutil/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libpostproc/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libswresample/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     | \
#            sed 's/include $$(SRC_PATH)\/subdir.mak/\#include $$(SRC_PATH)\/subdir.mak/g'                         > libswscale/Makefile.android; \
#            cd $$OLDPWD;
#    endif

#    ifeq ($(VERSION_BRANCH),0.8)
#        FF_FIX_MAKEFILES_COMMAND := \
#            cd $(FFMPEG_ROOT_DIR); \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         | \
#            sed 's/-include $$(SUBDIR)..\/$$(SUBDIR)$$(ARCH)\/Makefile/include $$(LOCAL_PATH)\/libavcodec\/$$(ARCH)\/Makefile/g' > libavcodec/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavdevice/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavfilter/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavformat/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavutil/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libpostproc/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswresample/Makefile  | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libswresample/Makefile.android; \
#            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     | \
#            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libswscale/Makefile.android; \
#            cd $$OLDPWD;
#    endif

    ifeq ($(VERSION_BRANCH),0.7)
        FF_FIX_MAKEFILES_COMMAND := \
            cd $(FFMPEG_ROOT_DIR); \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavcodec/Makefile     | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         | \
            sed 's/-include $$(SUBDIR)..\/$$(SUBDIR)$$(ARCH)\/Makefile/include $$(LOCAL_PATH)\/libavcodec\/$$(ARCH)\/Makefile/g' > libavcodec/Makefile.android; \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavdevice/Makefile    | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavdevice/Makefile.android; \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavfilter/Makefile    | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavfilter/Makefile.android; \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavformat/Makefile    | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavformat/Makefile.android; \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libavutil/Makefile      | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libavutil/Makefile.android; \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libpostproc/Makefile    | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libpostproc/Makefile.android; \
            sed 's/include $$(SUBDIR)..\/config.mak/\#include $$(SUBDIR)..\/config.mak/g' libswscale/Makefile     | \
            sed 's/include $$(SUBDIR)..\/subdir.mak/\#include $$(SUBDIR)..\/subdir.mak/g'                         > libswscale/Makefile.android; \
            cd $$OLDPWD;
    endif

    $(warning ============================================================)
    $(warning Fixing Makefiles...)
    #$(warning $(FF_FIX_MAKEFILES_COMMAND))
    FF_FIX_MAKEFILES_OUTPUT := $(shell $(FF_FIX_MAKEFILES_COMMAND))
    $(warning Done.)
    $(warning ============================================================)



    #Saving configuration
    FF_LAST_CONFIGURATION_STRING_COMMAND := \
        echo "$(FF_CONFIGURATION_STRING)" > $(FFMPEG_ROOT_DIR)/$(FFMPEG_CONFIG_DIR)/LAST_CONFIGURATION_STRING
    FF_LAST_CONFIGURATION_STRING_OUTPUT := $(shell $(FF_LAST_CONFIGURATION_STRING_COMMAND))

endif
