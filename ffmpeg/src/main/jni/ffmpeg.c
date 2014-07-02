#include <jni.h>
#include <string.h>
#include <stdio.h>
#include <android/log.h>
#include <android/bitmap.h>

#ifdef __cplusplus
extern "C"
{
#endif

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <libavutil/pixfmt.h>

#ifdef __cplusplus
}
#endif

#include "com_opensource_ffmpeg_android_test_MainActivity.h"

#define  LOG_TAG    "AndroidFFmpeg"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

/* Cheat to keep things simple and just use some globals. */
AVFormatContext *pFormatCtx;
AVCodecContext *pCodecCtx;
AVFrame *pFrame;
AVFrame *pFrameRGB;
int videoStream;

/*
 * Class:     com_opensource_ffmpegtest_MainActivity
 * Method:    openFile
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_opensource_ffmpeg_android_test_MainActivity_openFile
  (JNIEnv * env, jobject obj, jstring path) {
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    LOGE("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

int ret;
    int err;
    int i;
    AVCodec *pCodec;
    uint8_t *buffer;
    int numBytes;

    av_register_all();
    LOGE("Registered formats");
//    err = av_open_input_file(&pFormatCtx, "file:/sdcard/vid.3gp", NULL, 0, NULL);
//    err = av_open_input_file(&pFormatCtx, "/storage/extSdCard/DCIM/Camera/VID_20140502_085802.mp4", NULL, 0, NULL);
//    LOGE("Called open file");
//    if(err!=0) {
//        LOGE("Couldn't open file");
//        return;
//    }
//    LOGE("Opened file");
//
//    if(avformat_find_stream_info(pFormatCtx, NULL)<0) {
//        LOGE("Unable to get stream info");
//        return;
//    }

//    videoStream = -1;
//    for (i=0; i<pFormatCtx->nb_streams; i++) {
//        if(pFormatCtx->streams[i]->codec->codec_type==CODEC_TYPE_VIDEO) {
//            videoStream = i;
//            break;
//        }
//    }
//    if(videoStream==-1) {
//        LOGE("Unable to find video stream");
//        return;
//    }

//    LOGI("Video stream is [%d]", videoStream);
//
//    pCodecCtx=pFormatCtx->streams[videoStream]->codec;
//
//    pCodec=avcodec_find_decoder(pCodecCtx->codec_id);
//    if(pCodec==NULL) {
//        LOGE("Unsupported codec");
//        return;
//    }
//
//    if(av_open(pCodecCtx, pCodec)<0) {
//        LOGE("Unable to open codec");
//        return;
//    }
//
//    pFrame=av_frame_alloc();
//    pFrameRGB=av_frame_alloc();
//    LOGI("Video size is [%d x %d]", pCodecCtx->width, pCodecCtx->height);
//
//    numBytes=avpicture_get_size(PIX_FMT_RGB24, pCodecCtx->width, pCodecCtx->height);
//    buffer=(uint8_t *)av_malloc(numBytes*sizeof(uint8_t));
//
//    avpicture_fill((AVPicture *)pFrameRGB, buffer, PIX_FMT_RGB24,
//                            pCodecCtx->width, pCodecCtx->height);
}