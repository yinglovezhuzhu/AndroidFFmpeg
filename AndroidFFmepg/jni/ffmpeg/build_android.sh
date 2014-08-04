#!/bin/bash
NDK=$HOME/Android/android-ndk-r9d
SYSROOT=$NDK/platforms/android-9/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64
function build_one
{
#./configure \
#    --prefix=$PREFIX \
#    --enable-shared \
#    --disable-static \
#    --disable-ffmpeg \
#    --disable-doc \
#    --disable-ffplay \
#    --disable-ffprobe \
#    --disable-ffserver \
#    --disable-avdevice \
#    --disable-doc \
#    --disable-symver \
#    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
#    --target-os=linux \
#    --arch=arm \
#    --enable-cross-compile \
#    --sysroot=$SYSROOT \
#    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
#    --extra-ldflags="$ADDI_LDFLAGS" \
#    $ADDITIONAL_CONFIGURE_FLAG

./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --enable-bzlib \
    --enable-zlib \
    --enable-postproc \
    --enable-runtime-cpudetect \
    --enable-libx264 \
    --enable-gpl \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libshine \
    --enable-libmp3lame \
    --enable-gray \
    --enable-libass \
    --enable-libfreetype \
    --enable-libopenjpeg \
    --enable-libspeex \
    --enable-libvo-aacenc \
    --enable-libvo-amrwbenc \
    --enable-version3 \
    --enable-libvpx \
    --enable-filter=movie \
    --enable-frei0r \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
    
make clean
make
make install
}
CPU=arm
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm"
build_one
