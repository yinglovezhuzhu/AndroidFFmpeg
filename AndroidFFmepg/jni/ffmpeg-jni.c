/*
 * Copyright (c) 2000-2003 Fabrice Bellard
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

/**
 * @file
 * multimedia converter based on the FFmpeg libraries
 */

#include <android/log.h>
#include <ctype.h>
#include <errno.h>
#include <jni.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cmdutils.h"
#include "com_opensource_androidffmpeg_utils_FFmpegTool.h"
#include "ffmpeginentry.h"

#define  LOG_TAG    "ffmpeg-jni"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)
#define  LOGW(...)  __android_log_print(ANDROID_LOG_WARN,LOG_TAG,__VA_ARGS__);

///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    testLog
// * Signature: ()V
// */
//JNIEXPORT void JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_testLog
//  (JNIEnv * env, jclass obj)
//{
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    exit
// * Signature: (I)V
// */
//JNIEXPORT void JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_exit
//  (JNIEnv * env, jclass cls, jint code)
//{
//	exit_program(code);
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    mergeVideo
// * Signature: ([Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_mergeVideo
//  (JNIEnv * env, jclass cls, jstring folder, jstring output_path, jobjectArray files_array)
//{
//	int files_size = (*env)->GetArrayLength(env, files_array);
//	LOGI("%s%d\n", "File list size: ", files_size);
//	if(files_size < 2) {
//		return -1; //错误码-1,表示输入文件数不足
//	}
//
//	char const * cache_folder_path = (*env)->GetStringUTFChars(env, folder, 0);	//文件缓存路径
//	LOGI("%s %s %d", "cache foder path lenght:", cache_folder_path, strlen(cache_folder_path));
//	if(NULL == cache_folder_path) {
//		(*env)->ReleaseStringUTFChars(env, folder, cache_folder_path); //释放folder占用内存
//		return -2; //错误码-2,表示缓存目录（用来保存视频列表文件的目录）为空
//	}
//
//	char * video_list_file_name = "video-list"; //文件列表清单文件名
//
//	//用反射的方法获取当前系统下文件分割符
//	jclass file_class = (*env)->FindClass(env, "java/io/File");
//	jfieldID separator_field_id = (*env)->GetStaticFieldID(env, file_class, "separator", "Ljava/lang/String;");
//	jstring * separator_str = (*env)->GetStaticObjectField(env, file_class, separator_field_id);
//	char const *separator = (*env)->GetStringUTFChars(env, separator_str, 0);
//	LOGI("%s %s", "System file separator", separator);
//
//	char *last_char = &cache_folder_path[strlen(cache_folder_path) - 1];
//	LOGI("%s %s", "Last char ", last_char);
//	int need_separator = (*separator == *last_char) ? 0 : 1; //是否需要在目录路径后添加路径分隔符，0表示不需要，1表示需要
//	LOGI("%s %d", "Need separator ", need_separator);
//	char * video_list_file_path = malloc(strlen(cache_folder_path) + strlen(video_list_file_name) + need_separator + 1);
//	strcpy(video_list_file_path, cache_folder_path);
//	if(need_separator == 1) {	//如果需要添加路径分隔符，添加一个分隔符
//		strcat(video_list_file_path, separator);
//	}
//	strcat(video_list_file_path, video_list_file_name);
//	LOGI("%s %s", "Video list file path: ", video_list_file_path);
//
//	FILE * list_file = fopen(video_list_file_path, "wt+");	//打开视频列表清单文件
//	if(NULL == list_file) {
//		LOGE("Can't open or create list file");
//		(*env)->ReleaseStringUTFChars(env, separator_str, separator);	//释放seperator占用内存
//		return -3; //错误码-3,表示打开视频列表文件失败
//	}
//
//	int i = 0;
//	for(i = 0; i < files_size; i++) { //循环将传入的文件写入清单列表中
//		jstring file_str = (*env)->GetObjectArrayElement(env, files_array, i);
//		char const * file = (*env)->GetStringUTFChars(env, file_str, 0);
//		if(NULL != file) {
//			fprintf(list_file, "%s %s%s%s\n", "file", "'", file, "'");
////			fprintf(list_file, "%s %s", "file", file);
//			LOGI("%s", file);
//		}
////		(*env)->ReleaseStringUTFChars(env, file_str, file); //释放file占用内存，在此释放会造成乱码
//	}
//	fflush(list_file);
//	fclose(list_file);
//
//	char const * output_file_path = (*env)->GetStringUTFChars(env, output_path, 0);
//	int argc = 11; //参数个数
//	char *argv [11];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-f";
//	argv[3] = "concat";
//	argv[4] = "-i";
//	argv[5] = video_list_file_path;
//	argv[6] = "-vcodec";
//	argv[7] = "copy";
//	argv[8] = "-acodec";
//	argv[9] = "copy";
//	argv[10] = output_file_path;
//
//	int ret = main(argc, argv);
//
////	ffmpeg -f concat -i mylist.txt -c copy output.mkv
//
//	(*env)->ReleaseStringUTFChars(env, output_path, output_file_path); //释放输出文件字符串内存
//	(*env)->ReleaseStringUTFChars(env, separator_str, separator);	//释放seperator占用内存
//	(*env)->ReleaseStringUTFChars(env, folder, cache_folder_path); //释放folder占用内存
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    cutVideo
// * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_cutVideo
//  (JNIEnv * env, jclass cls, jstring input_file, jstring start_time, jstring duration, jstring output_file)
//{
//	char const * input_file_path = (*env)->GetStringUTFChars(env, input_file, 0);
//	if(NULL == input_file_path)
//	{
//		return -1; //错误码-1,输入文件为空
//	}
//	char const * output_file_path = (*env)->GetStringUTFChars(env, output_file, 0);
//	if(NULL == output_file_path)
//	{
//		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//		return -2; //错误吗-2,输出文件为空
//	}
//	char const * video_start_time = (*env)->GetStringUTFChars(env, start_time, 0);
//	if(NULL == video_start_time)
//	{
//		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//		(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//		return -3; //错误码-3,开始时间为空
//	}
//	char const * video_duration = (*env)->GetStringUTFChars(env, duration, 0);
//	if(NULL == video_duration)
//	{
//		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//		(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//		(*env)->ReleaseStringUTFChars(env, video_start_time, start_time);
//		return -4; //错误码-4,开始时间为空
//	}
//
//	LOGI("%s %s", "Input file:", input_file_path);
//	LOGI("%s %s", "Output file:", output_file_path);
//	LOGI("%s %s", "Startt time:", video_start_time);
//	LOGI("%s %s", "Duration:", video_duration);
//
//	int argc = 13;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_file_path;
//	argv[4] = "-ss";
//	argv[5] = video_start_time;
//	argv[6] = "-t";
//	argv[7] = video_duration;
//	argv[8] = "-vcodec";
//	argv[9] = "copy";
//	argv[10] = "-acodec";
//	argv[11] = "copy";
//	argv[12] = output_file_path;
//
//	LOGI("%s %s %s %s %s %s %s %s %s %s %s %s %s", argv[0], argv[1], argv[2], argv[3], argv[4],
//			argv[5], argv[6], argv[7], argv[8], argv[9], argv[10], argv[11], argv[12]);
//
//
//	int ret = main(argc, argv);
//
//	LOGI("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
//
////	ffmpeg -i input.mp4 -ss **START_TIME** -t **STOP_TIME** -acodec copy -vcodec copy output.mp4
////	其中 START_TIME/STOP_TIME 的格式可以写成两种格式：
////
////	以秒为单位计数： 80
////	时:分:秒： 00:01:20
//
//	(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//	(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//	(*env)->ReleaseStringUTFChars(env, start_time, video_start_time);
//	(*env)->ReleaseStringUTFChars(env, duration, video_duration);
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    addWaterMark
// * Signature: (Ljava/lang/String;Ljava/lang/String;III)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_addWaterMark
//  (JNIEnv * env, jclass cls, jstring video_file, jstring image_file, jint position, jstring x, jstring y, jstring output_file, jstring format)
//{
//	LOGI("%s %d", "Postion:", position);
//	char const *video_file_path = (*env)->GetStringUTFChars(env, video_file, 0);
//	if(NULL == video_file_path)
//	{
//		return -1; //错误码-1,输入视频文件为空
//	}
//	LOGI("%s %s", "Video file:", video_file_path);
//	char const *image_file_path = (*env)->GetStringUTFChars(env, image_file, 0);
//	if(NULL == image_file_path)
//	{
//		(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
//		return -2; //错误码-2,输出图片文件为空
//	}
//	char const *output_file_path = (*env)->GetStringUTFChars(env, output_file, 0);
//	if(NULL == output_file_path)
//	{
//		(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
//		(*env)->ReleaseStringUTFChars(env, image_file, image_file_path);
//		return -3; //错误码-3,输出文件为空
//	}
//	LOGI("%s %s", "Image file:", image_file_path);
//	char const * output_format = (*env)->GetStringUTFChars(env, format, 0);
//
//
//	char const * x_offset = (*env)->GetStringUTFChars(env, x, 0);
//	char const * y_offset = (*env)->GetStringUTFChars(env, y, 0);
//	if(NULL == x_offset)
//	{
//		x_offset = "0";
//	}
//	if(NULL == y_offset)
//	{
//		y_offset = "0";
//	}
//
//	char * overlay = "overlay";
//	char *water_mark_position;
//	char *position_mid = "overlay=(W-w)/2:(H-h)/2";
//	switch (position) {
//		case 0: //中间
//			water_mark_position = "overlay=(W-w)/2:(H-h)/2";
//			break;
//		case 1: //左上角
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 2);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, ":");
//			strcat(water_mark_position, y_offset);
////			char * video_list_file_path = malloc(strlen(cache_folder_path) + strlen(video_list_file_name) + need_separator + 1);
////				strcpy(video_list_file_path, cache_folder_path);
//			break;
//		case 2: //右上角
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 8);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, "(W-w-");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, "):");
//			strcat(water_mark_position, y_offset);
//			break;
//		case 3:
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 8);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, ":(H-h-");
//			strcat(water_mark_position, y_offset);
//			strcat(water_mark_position, ")");
//			break;
//		case 4:
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 13);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, "(W-w-");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, "):(H-h-");
//			strcat(water_mark_position, y_offset);
//			strcat(water_mark_position, ")");
//			break;
//		default:
//			water_mark_position = NULL;
//			break;
//	}
//
//	if(NULL == water_mark_position) {
//		return -4; //错误码-4,输入的水印位置错误
//	}
//
//	LOGI("Watermark position: %d : %s", position, water_mark_position);
//
//	int argc = 21;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
////	argv[3] = "/sdcard/DCIM/Camera/VID_19700110_122102.3gp";
////	argv[3] = "/mnt/sdcard/DCIM/Camera/VID_20140708_205441.mp4";
//	argv[3] = video_file_path;
//	argv[4] = "-i";
////	argv[5] = "/sdcard/DCIM/Camera/photo.png";
////	argv[5] = "/mnt/sdcard/fb.png";
//	argv[5] = image_file_path;
//	argv[6] = "-filter_complex";
////	argv[7] = "overlay=(W-w)/2:(H-h)/2";
//	argv[7] = water_mark_position;
//	argv[8] = "-c:v";
//	argv[9] = "mpeg4";
//	argv[10] = "-c:a";
//	argv[11] = "copy";
//	argv[12] = "-c:s";
//	argv[13] = "copy";
//	argv[14] = "-b:v";
//	argv[15] = "1000k";
//	argv[16] = "-s";
//	argv[17] = "480x480";
//	argv[18] = "-f";
//	argv[19] = "mp4";
////	argv[20] = "/mnt/sdcard/DCIM/Camera/VID_20140708_205441_watermark.mp4";
//	argv[20] = output_file_path;
////	ffmpeg [-y] -i **VIDEO_INPUT** -i **IMAGE_INPUT** -filter_complex 'overlay=**x**:**y**'
////	-c:v **VIDEO_CODEC** -c:a copy -c:s copy -b:v **VIDEO_BITRATE** -s **VIDEO_SIZE** -f **OUTPUT_FORMAT** **VIDEO_OUTPUT**
//
//	int ret = main(argc, argv);
//
//
//	(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
//	(*env)->ReleaseStringUTFChars(env, image_file, image_file_path);
//	(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//	(*env)->ReleaseStringUTFChars(env, format, output_format);
//	(*env)->ReleaseStringUTFChars(env, x, x_offset);
//	(*env)->ReleaseStringUTFChars(env, y, y_offset);
//	return ret;
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    removeAudio
// * Signature: (Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_removeAudio
//  (JNIEnv * env, jclass cls, jstring input, jstring output)
//{
//	char const *input_video_path = (*env)->GetStringUTFChars(env, input, 0);
//	if(NULL == input_video_path) {
//		return -1;
//	}
//	char const *output_video_path = (*env)->GetStringUTFChars(env, output, 0);
//	if(NULL == output_video_path) {
//		(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//		return -2;
//	}
//
//	int argc =8;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_video_path;
//	argv[4] = "-vcodec";
//	argv[5] = "copy";
//	argv[6] = "-an";
//	argv[7] = output_video_path;
//
//	int ret = main(argc, argv);
//
//	//ffmpeg -i 1.avi -vcodec copy -an 2.avi
//	(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//	(*env)->ReleaseStringUTFChars(env, output, output_video_path);
//	return ret;
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    fetchAudio
// * Signature: (Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_fetchAudio
//  (JNIEnv * env, jclass cls, jstring input, jstring output, jstring format)
//{
//	char const *input_video_path = (*env)->GetStringUTFChars(env, input, 0);
//	if(NULL == input_video_path) {
//		return -1;
//	}
//	char const *output_audio_path = (*env)->GetStringUTFChars(env, output, 0);
//	if(NULL == output_audio_path) {
//		(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//		return -2;
//	}
//	char const *audio_format = (*env)->GetStringUTFChars(env, format, 0);
//
//	int argc = 8;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_video_path;
//	argv[4] = "-f";
//	if(NULL == audio_format) {
//		argv[5] = "wav";
//	} else {
//		argv[5] = audio_format;
//	}
//	argv[6] = "-vn";
//	argv[7] = output_audio_path;
//
//		LOGW("%s %s %s %s %s %s %s %s",
//				argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7]);
//
//	int ret = main(argc, argv);
//
////	ffmpeg -i src.avi -f wav -vn -y dest1.wav
//
//	(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//	(*env)->ReleaseStringUTFChars(env, output, output_audio_path);
//	(*env)->ReleaseStringUTFChars(env, format, audio_format);
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    addAudio
// * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_addAudio
//  (JNIEnv * env, jclass cls, jstring video, jstring audio, jstring output, jstring format)
//{
//	char const *input_video_path = (*env)->GetStringUTFChars(env, video, 0);
//	if(NULL == input_video_path) {
//		return -1;
//	}
//	char const *input_audio_path = (*env)->GetStringUTFChars(env, audio, 0);
//	if(NULL == input_audio_path) {
//		(*env)->ReleaseStringUTFChars(env, video, input_video_path);
//		return -2;
//	}
//	char const *output_video_path = (*env)->GetStringUTFChars(env, output, 0);
//	if(NULL == output_video_path) {
//		(*env)->ReleaseStringUTFChars(env, video, input_video_path);
//		(*env)->ReleaseStringUTFChars(env, audio, input_audio_path);
//		return -3;
//	}
//
//	char const *output_format = (*env)->GetStringUTFChars(env, format, 0);
//
//	int argc = 21;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_video_path;
//	argv[4] = "-i";
//	argv[5] = input_audio_path;
//	argv[6] = "-c:v";
//	argv[7] = "mpeg4";
//	argv[8] = "-c:a";
//	argv[9] = "ac3";
//	argv[10] = "-c:s";
//	argv[11] = "copy";
//	argv[12] = "-b:v";
//	argv[13] = "1000k";
//	argv[14] = "-b:a";
//	argv[15] = "128k";
////	argv[16] = "-s";
////	argv[17] = "640x480";
//	argv[16] = "-ac";
//	argv[17] = "1";
//	argv[18] = "-f";
//	argv[19] = "mp4";
//	argv[20] = "/sdcard/DCIM/Camera/add_audio_out.mp4";
////	argv[20] = output_video_path;
//		LOGW("%s %s %s %s %s %s %s %s %s",
//				argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8]);
//
////		argv[8] = "-c:v";
////			argv[9] = "mpeg4";
////			argv[10] = "-c:a";
////			argv[11] = "copy";
////			argv[12] = "-c:s";
////			argv[13] = "copy";
////			argv[14] = "-b:v";
////			argv[15] = "1000k";
////			argv[16] = "-s";
////			argv[17] = "640x480";
////			argv[18] = "-f";
////			argv[19] = "3gp";
////			argv[20] = "/sdcard/DCIM/Camera/watermark_out.3gp";
//
//	int ret = main(argc, argv);
//
////	ffmpeg -i **INPUT_AUDIO** -i **INPUT_VIDEO** **OUTPUT_VIDEO**
//	(*env)->ReleaseStringUTFChars(env, video, input_video_path);
//	(*env)->ReleaseStringUTFChars(env, audio, input_audio_path);
//	(*env)->ReleaseStringUTFChars(env, output, output_video_path);
//	(*env)->ReleaseStringUTFChars(env, format, output_format);
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_androidffmpeg_utils_FFmpegTool
// * Method:    ffmpeg
// * Signature: (I[Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_androidffmpeg_utils_FFmpegTool_ffmpeg
//  (JNIEnv * env, jclass cls, jobjectArray args) {
//	int argc = (*env)->GetArrayLength(env, args);
//	char *argv[argc];
//	int i = 0;
//	for(i = 0; i < argc; i++) { //循环将传入的文件写入清单列表中
//			jstring str = (*env)->GetObjectArrayElement(env, args, i);
//			char const * arg = (*env)->GetStringUTFChars(env, str, 0);
//			argv[i] = arg;
//	}
//	return main(argc, argv);
//}


/****************************************************************************************************************************************/
/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    testLog
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_testLog
  (JNIEnv * env, jclass obj)
{
	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    exit
 * Signature: (I)V
 */
JNIEXPORT void JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_exit
  (JNIEnv * env, jclass cls, jint code)
{
	exit_program(code);
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    mergeVideo
 * Signature: ([Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_mergeVideo
  (JNIEnv * env, jclass cls, jstring folder, jstring output_path, jobjectArray files_array)
{
	int files_size = (*env)->GetArrayLength(env, files_array);
	LOGI("%s%d\n", "File list size: ", files_size);
	if(files_size < 2) {
		return -1; //错误码-1,表示输入文件数不足
	}

	char const * cache_folder_path = (*env)->GetStringUTFChars(env, folder, 0);	//文件缓存路径
	LOGI("%s %s %d", "cache foder path lenght:", cache_folder_path, strlen(cache_folder_path));
	if(NULL == cache_folder_path) {
		(*env)->ReleaseStringUTFChars(env, folder, cache_folder_path); //释放folder占用内存
		return -2; //错误码-2,表示缓存目录（用来保存视频列表文件的目录）为空
	}

	char * video_list_file_name = "video-list"; //文件列表清单文件名

	//用反射的方法获取当前系统下文件分割符
	jclass file_class = (*env)->FindClass(env, "java/io/File");
	jfieldID separator_field_id = (*env)->GetStaticFieldID(env, file_class, "separator", "Ljava/lang/String;");
	jstring * separator_str = (*env)->GetStaticObjectField(env, file_class, separator_field_id);
	char const *separator = (*env)->GetStringUTFChars(env, separator_str, 0);
	LOGI("%s %s", "System file separator", separator);

	char *last_char = &cache_folder_path[strlen(cache_folder_path) - 1];
	LOGI("%s %s", "Last char ", last_char);
	int need_separator = (*separator == *last_char) ? 0 : 1; //是否需要在目录路径后添加路径分隔符，0表示不需要，1表示需要
	LOGI("%s %d", "Need separator ", need_separator);
	char * video_list_file_path = malloc(strlen(cache_folder_path) + strlen(video_list_file_name) + need_separator + 1);
	strcpy(video_list_file_path, cache_folder_path);
	if(need_separator == 1) {	//如果需要添加路径分隔符，添加一个分隔符
		strcat(video_list_file_path, separator);
	}
	strcat(video_list_file_path, video_list_file_name);
	LOGI("%s %s", "Video list file path: ", video_list_file_path);

	FILE * list_file = fopen(video_list_file_path, "wt+");	//打开视频列表清单文件
	if(NULL == list_file) {
		LOGE("Can't open or create list file");
		(*env)->ReleaseStringUTFChars(env, separator_str, separator);	//释放seperator占用内存
		return -3; //错误码-3,表示打开视频列表文件失败
	}

	int i = 0;
	for(i = 0; i < files_size; i++) { //循环将传入的文件写入清单列表中
		jstring file_str = (*env)->GetObjectArrayElement(env, files_array, i);
		char const * file = (*env)->GetStringUTFChars(env, file_str, 0);
		if(NULL != file) {
			fprintf(list_file, "%s %s%s%s\n", "file", "'", file, "'");
//			fprintf(list_file, "%s %s", "file", file);
			LOGI("%s", file);
		}
//		(*env)->ReleaseStringUTFChars(env, file_str, file); //释放file占用内存，在此释放会造成乱码
	}
	fflush(list_file);
	fclose(list_file);

	char const * output_file_path = (*env)->GetStringUTFChars(env, output_path, 0);
	int argc = 11; //参数个数
	char *argv [11];
	argv[0] = "ffmpeg";
	argv[1] = "-y";
	argv[2] = "-f";
	argv[3] = "concat";
	argv[4] = "-i";
	argv[5] = video_list_file_path;
	argv[6] = "-vcodec";
	argv[7] = "copy";
	argv[8] = "-acodec";
	argv[9] = "copy";
	argv[10] = output_file_path;

	int ret = main(argc, argv);

//	ffmpeg -f concat -i mylist.txt -c copy output.mkv

	(*env)->ReleaseStringUTFChars(env, output_path, output_file_path); //释放输出文件字符串内存
	(*env)->ReleaseStringUTFChars(env, separator_str, separator);	//释放seperator占用内存
	(*env)->ReleaseStringUTFChars(env, folder, cache_folder_path); //释放folder占用内存

	return ret;
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    cutVideo
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_cutVideo
  (JNIEnv * env, jclass cls, jstring input_file, jstring start_time, jstring duration, jstring output_file)
{
	char const * input_file_path = (*env)->GetStringUTFChars(env, input_file, 0);
	if(NULL == input_file_path)
	{
		return -1; //错误码-1,输入文件为空
	}
	char const * output_file_path = (*env)->GetStringUTFChars(env, output_file, 0);
	if(NULL == output_file_path)
	{
		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
		return -2; //错误吗-2,输出文件为空
	}
	char const * video_start_time = (*env)->GetStringUTFChars(env, start_time, 0);
	if(NULL == video_start_time)
	{
		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
		(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
		return -3; //错误码-3,开始时间为空
	}
	char const * video_duration = (*env)->GetStringUTFChars(env, duration, 0);
	if(NULL == video_duration)
	{
		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
		(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
		(*env)->ReleaseStringUTFChars(env, video_start_time, start_time);
		return -4; //错误码-4,开始时间为空
	}

	LOGI("%s %s", "Input file:", input_file_path);
	LOGI("%s %s", "Output file:", output_file_path);
	LOGI("%s %s", "Startt time:", video_start_time);
	LOGI("%s %s", "Duration:", video_duration);

	int argc = 13;
	char *argv[argc];
	argv[0] = "ffmpeg";
	argv[1] = "-y";
	argv[2] = "-i";
	argv[3] = input_file_path;
	argv[4] = "-ss";
	argv[5] = video_start_time;
	argv[6] = "-t";
	argv[7] = video_duration;
	argv[8] = "-vcodec";
	argv[9] = "copy";
	argv[10] = "-acodec";
	argv[11] = "copy";
	argv[12] = output_file_path;

	LOGI("%s %s %s %s %s %s %s %s %s %s %s %s %s", argv[0], argv[1], argv[2], argv[3], argv[4],
			argv[5], argv[6], argv[7], argv[8], argv[9], argv[10], argv[11], argv[12]);


	int ret = main(argc, argv);

	LOGI("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

//	ffmpeg -i input.mp4 -ss **START_TIME** -t **STOP_TIME** -acodec copy -vcodec copy output.mp4
//	其中 START_TIME/STOP_TIME 的格式可以写成两种格式：
//
//	以秒为单位计数： 80
//	时:分:秒： 00:01:20

	(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
	(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
	(*env)->ReleaseStringUTFChars(env, start_time, video_start_time);
	(*env)->ReleaseStringUTFChars(env, duration, video_duration);

	return ret;
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    addWaterMark
 * Signature: (Ljava/lang/String;Ljava/lang/String;III)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_addWaterMark
  (JNIEnv * env, jclass cls, jstring video_file, jstring image_file, jint position, jstring x, jstring y, jstring output_file, jstring format)
{
	LOGI("%s %d", "Postion:", position);
	char const *video_file_path = (*env)->GetStringUTFChars(env, video_file, 0);
	if(NULL == video_file_path)
	{
		return -1; //错误码-1,输入视频文件为空
	}
	LOGI("%s %s", "Video file:", video_file_path);
	char const *image_file_path = (*env)->GetStringUTFChars(env, image_file, 0);
	if(NULL == image_file_path)
	{
		(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
		return -2; //错误码-2,输出图片文件为空
	}
	char const *output_file_path = (*env)->GetStringUTFChars(env, output_file, 0);
	if(NULL == output_file_path)
	{
		(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
		(*env)->ReleaseStringUTFChars(env, image_file, image_file_path);
		return -3; //错误码-3,输出文件为空
	}
	LOGI("%s %s", "Image file:", image_file_path);
	char const * output_format = (*env)->GetStringUTFChars(env, format, 0);


	char const * x_offset = (*env)->GetStringUTFChars(env, x, 0);
	char const * y_offset = (*env)->GetStringUTFChars(env, y, 0);
	if(NULL == x_offset)
	{
		x_offset = "0";
	}
	if(NULL == y_offset)
	{
		y_offset = "0";
	}

	char * overlay = "overlay";
	char *water_mark_position;
	char *position_mid = "overlay=(W-w)/2:(H-h)/2";
	switch (position) {
		case 0: //中间
			water_mark_position = "overlay=(W-w)/2:(H-h)/2";
			break;
		case 1: //左上角
			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 2);
			strcpy(water_mark_position, overlay);
			strcat(water_mark_position, "=");
			strcat(water_mark_position, x_offset);
			strcat(water_mark_position, ":");
			strcat(water_mark_position, y_offset);
//			char * video_list_file_path = malloc(strlen(cache_folder_path) + strlen(video_list_file_name) + need_separator + 1);
//				strcpy(video_list_file_path, cache_folder_path);
			break;
		case 2: //右上角
			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 8);
			strcpy(water_mark_position, overlay);
			strcat(water_mark_position, "=");
			strcat(water_mark_position, "(W-w-");
			strcat(water_mark_position, x_offset);
			strcat(water_mark_position, "):");
			strcat(water_mark_position, y_offset);
			break;
		case 3:
			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 8);
			strcpy(water_mark_position, overlay);
			strcat(water_mark_position, "=");
			strcat(water_mark_position, x_offset);
			strcat(water_mark_position, ":(H-h-");
			strcat(water_mark_position, y_offset);
			strcat(water_mark_position, ")");
			break;
		case 4:
			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 13);
			strcpy(water_mark_position, overlay);
			strcat(water_mark_position, "=");
			strcat(water_mark_position, "(W-w-");
			strcat(water_mark_position, x_offset);
			strcat(water_mark_position, "):(H-h-");
			strcat(water_mark_position, y_offset);
			strcat(water_mark_position, ")");
			break;
		default:
			water_mark_position = NULL;
			break;
	}

	if(NULL == water_mark_position) {
		return -4; //错误码-4,输入的水印位置错误
	}

	LOGI("Watermark position: %d : %s", position, water_mark_position);

	int argc = 21;
	char *argv[argc];
	argv[0] = "ffmpeg";
	argv[1] = "-y";
	argv[2] = "-i";
//	argv[3] = "/sdcard/DCIM/Camera/VID_19700110_122102.3gp";
//	argv[3] = "/mnt/sdcard/DCIM/Camera/VID_20140708_205441.mp4";
	argv[3] = video_file_path;
	argv[4] = "-i";
//	argv[5] = "/sdcard/DCIM/Camera/photo.png";
//	argv[5] = "/mnt/sdcard/fb.png";
	argv[5] = image_file_path;
	argv[6] = "-filter_complex";
//	argv[7] = "overlay=(W-w)/2:(H-h)/2";
	argv[7] = water_mark_position;
	argv[8] = "-c:v";
	argv[9] = "mpeg4";
	argv[10] = "-c:a";
	argv[11] = "copy";
	argv[12] = "-c:s";
	argv[13] = "copy";
	argv[14] = "-b:v";
	argv[15] = "1000k";
	argv[16] = "-s";
	argv[17] = "480x480";
	argv[18] = "-f";
	argv[19] = "mp4";
//	argv[20] = "/mnt/sdcard/DCIM/Camera/VID_20140708_205441_watermark.mp4";
	argv[20] = output_file_path;
//	ffmpeg [-y] -i **VIDEO_INPUT** -i **IMAGE_INPUT** -filter_complex 'overlay=**x**:**y**'
//	-c:v **VIDEO_CODEC** -c:a copy -c:s copy -b:v **VIDEO_BITRATE** -s **VIDEO_SIZE** -f **OUTPUT_FORMAT** **VIDEO_OUTPUT**

	int ret = main(argc, argv);


	(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
	(*env)->ReleaseStringUTFChars(env, image_file, image_file_path);
	(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
	(*env)->ReleaseStringUTFChars(env, format, output_format);
	(*env)->ReleaseStringUTFChars(env, x, x_offset);
	(*env)->ReleaseStringUTFChars(env, y, y_offset);
	return ret;
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    removeAudio
 * Signature: (Ljava/lang/String;Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_removeAudio
  (JNIEnv * env, jclass cls, jstring input, jstring output)
{
	char const *input_video_path = (*env)->GetStringUTFChars(env, input, 0);
	if(NULL == input_video_path) {
		return -1;
	}
	char const *output_video_path = (*env)->GetStringUTFChars(env, output, 0);
	if(NULL == output_video_path) {
		(*env)->ReleaseStringUTFChars(env, input, input_video_path);
		return -2;
	}

	int argc =8;
	char *argv[argc];
	argv[0] = "ffmpeg";
	argv[1] = "-y";
	argv[2] = "-i";
	argv[3] = input_video_path;
	argv[4] = "-vcodec";
	argv[5] = "copy";
	argv[6] = "-an";
	argv[7] = output_video_path;

	int ret = main(argc, argv);

	//ffmpeg -i 1.avi -vcodec copy -an 2.avi
	(*env)->ReleaseStringUTFChars(env, input, input_video_path);
	(*env)->ReleaseStringUTFChars(env, output, output_video_path);
	return ret;
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    fetchAudio
 * Signature: (Ljava/lang/String;Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_fetchAudio
  (JNIEnv * env, jclass cls, jstring input, jstring output, jstring format)
{
	char const *input_video_path = (*env)->GetStringUTFChars(env, input, 0);
	if(NULL == input_video_path) {
		return -1;
	}
	char const *output_audio_path = (*env)->GetStringUTFChars(env, output, 0);
	if(NULL == output_audio_path) {
		(*env)->ReleaseStringUTFChars(env, input, input_video_path);
		return -2;
	}
	char const *audio_format = (*env)->GetStringUTFChars(env, format, 0);

	int argc = 8;
	char *argv[argc];
	argv[0] = "ffmpeg";
	argv[1] = "-y";
	argv[2] = "-i";
	argv[3] = input_video_path;
	argv[4] = "-f";
	if(NULL == audio_format) {
		argv[5] = "wav";
	} else {
		argv[5] = audio_format;
	}
	argv[6] = "-vn";
	argv[7] = output_audio_path;

		LOGW("%s %s %s %s %s %s %s %s",
				argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7]);

	int ret = main(argc, argv);

//	ffmpeg -i src.avi -f wav -vn -y dest1.wav

	(*env)->ReleaseStringUTFChars(env, input, input_video_path);
	(*env)->ReleaseStringUTFChars(env, output, output_audio_path);
	(*env)->ReleaseStringUTFChars(env, format, audio_format);

	return ret;
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    addAudio
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_addAudio
  (JNIEnv * env, jclass cls, jstring video, jstring audio, jstring output, jstring format)
{
	char const *input_video_path = (*env)->GetStringUTFChars(env, video, 0);
	if(NULL == input_video_path) {
		return -1;
	}
	char const *input_audio_path = (*env)->GetStringUTFChars(env, audio, 0);
	if(NULL == input_audio_path) {
		(*env)->ReleaseStringUTFChars(env, video, input_video_path);
		return -2;
	}
	char const *output_video_path = (*env)->GetStringUTFChars(env, output, 0);
	if(NULL == output_video_path) {
		(*env)->ReleaseStringUTFChars(env, video, input_video_path);
		(*env)->ReleaseStringUTFChars(env, audio, input_audio_path);
		return -3;
	}

	char const *output_format = (*env)->GetStringUTFChars(env, format, 0);

	int argc = 21;
	char *argv[argc];
	argv[0] = "ffmpeg";
	argv[1] = "-y";
	argv[2] = "-i";
	argv[3] = input_video_path;
	argv[4] = "-i";
	argv[5] = input_audio_path;
	argv[6] = "-c:v";
	argv[7] = "mpeg4";
	argv[8] = "-c:a";
	argv[9] = "ac3";
	argv[10] = "-c:s";
	argv[11] = "copy";
	argv[12] = "-b:v";
	argv[13] = "1000k";
	argv[14] = "-b:a";
	argv[15] = "128k";
//	argv[16] = "-s";
//	argv[17] = "640x480";
	argv[16] = "-ac";
	argv[17] = "1";
	argv[18] = "-f";
	argv[19] = "mp4";
	argv[20] = "/sdcard/DCIM/Camera/add_audio_out.mp4";
//	argv[20] = output_video_path;
		LOGW("%s %s %s %s %s %s %s %s %s",
				argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8]);

//		argv[8] = "-c:v";
//			argv[9] = "mpeg4";
//			argv[10] = "-c:a";
//			argv[11] = "copy";
//			argv[12] = "-c:s";
//			argv[13] = "copy";
//			argv[14] = "-b:v";
//			argv[15] = "1000k";
//			argv[16] = "-s";
//			argv[17] = "640x480";
//			argv[18] = "-f";
//			argv[19] = "3gp";
//			argv[20] = "/sdcard/DCIM/Camera/watermark_out.3gp";

	int ret = main(argc, argv);

//	ffmpeg -i **INPUT_AUDIO** -i **INPUT_VIDEO** **OUTPUT_VIDEO**
	(*env)->ReleaseStringUTFChars(env, video, input_video_path);
	(*env)->ReleaseStringUTFChars(env, audio, input_audio_path);
	(*env)->ReleaseStringUTFChars(env, output, output_video_path);
	(*env)->ReleaseStringUTFChars(env, format, output_format);

	return ret;
}

/*
 * Class:     com_cn21_vgo_camcorder_utils_FFmpegTool
 * Method:    ffmpeg
 * Signature: (I[Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_com_cn21_vgo_camcorder_utils_FFmpegTool_ffmpeg
  (JNIEnv * env, jclass cls, jobjectArray args) {
	int argc = (*env)->GetArrayLength(env, args);
	char *argv[argc];
	int i = 0;
	for(i = 0; i < argc; i++) { //循环将传入的文件写入清单列表中
			jstring str = (*env)->GetObjectArrayElement(env, args, i);
			char const * arg = (*env)->GetStringUTFChars(env, str, 0);
			argv[i] = arg;
	}
	return main(argc, argv);
}

/**********************************************************************************************************************************************/
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    testLog
// * Signature: ()V
// */
//JNIEXPORT void JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_testLog
//  (JNIEnv * env, jclass obj)
//{
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//	LOGE("FFmpeg-jni Test log ++++++++>>>>>>>>>>>>>>>>>>>>>>>^_^");
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    exit
// * Signature: (I)V
// */
//JNIEXPORT void JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_exit
//  (JNIEnv * env, jclass cls, jint code)
//{
//	exit_program(code);
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    mergeVideo
// * Signature: ([Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_mergeVideo
//  (JNIEnv * env, jclass cls, jstring folder, jstring output_path, jobjectArray files_array)
//{
//	int files_size = (*env)->GetArrayLength(env, files_array);
//	LOGI("%s%d\n", "File list size: ", files_size);
//	if(files_size < 2) {
//		return -1; //错误码-1,表示输入文件数不足
//	}
//
//	char const * cache_folder_path = (*env)->GetStringUTFChars(env, folder, 0);	//文件缓存路径
//	LOGI("%s %s %d", "cache foder path lenght:", cache_folder_path, strlen(cache_folder_path));
//	if(NULL == cache_folder_path) {
//		(*env)->ReleaseStringUTFChars(env, folder, cache_folder_path); //释放folder占用内存
//		return -2; //错误码-2,表示缓存目录（用来保存视频列表文件的目录）为空
//	}
//
//	char * video_list_file_name = "video-list"; //文件列表清单文件名
//
//	//用反射的方法获取当前系统下文件分割符
//	jclass file_class = (*env)->FindClass(env, "java/io/File");
//	jfieldID separator_field_id = (*env)->GetStaticFieldID(env, file_class, "separator", "Ljava/lang/String;");
//	jstring * separator_str = (*env)->GetStaticObjectField(env, file_class, separator_field_id);
//	char const *separator = (*env)->GetStringUTFChars(env, separator_str, 0);
//	LOGI("%s %s", "System file separator", separator);
//
//	char *last_char = &cache_folder_path[strlen(cache_folder_path) - 1];
//	LOGI("%s %s", "Last char ", last_char);
//	int need_separator = (*separator == *last_char) ? 0 : 1; //是否需要在目录路径后添加路径分隔符，0表示不需要，1表示需要
//	LOGI("%s %d", "Need separator ", need_separator);
//	char * video_list_file_path = malloc(strlen(cache_folder_path) + strlen(video_list_file_name) + need_separator + 1);
//	strcpy(video_list_file_path, cache_folder_path);
//	if(need_separator == 1) {	//如果需要添加路径分隔符，添加一个分隔符
//		strcat(video_list_file_path, separator);
//	}
//	strcat(video_list_file_path, video_list_file_name);
//	LOGI("%s %s", "Video list file path: ", video_list_file_path);
//
//	FILE * list_file = fopen(video_list_file_path, "wt+");	//打开视频列表清单文件
//	if(NULL == list_file) {
//		LOGE("Can't open or create list file");
//		(*env)->ReleaseStringUTFChars(env, separator_str, separator);	//释放seperator占用内存
//		return -3; //错误码-3,表示打开视频列表文件失败
//	}
//
//	int i = 0;
//	for(i = 0; i < files_size; i++) { //循环将传入的文件写入清单列表中
//		jstring file_str = (*env)->GetObjectArrayElement(env, files_array, i);
//		char const * file = (*env)->GetStringUTFChars(env, file_str, 0);
//		if(NULL != file) {
//			fprintf(list_file, "%s %s%s%s\n", "file", "'", file, "'");
////			fprintf(list_file, "%s %s", "file", file);
//			LOGI("%s", file);
//		}
////		(*env)->ReleaseStringUTFChars(env, file_str, file); //释放file占用内存，在此释放会造成乱码
//	}
//	fflush(list_file);
//	fclose(list_file);
//
//	char const * output_file_path = (*env)->GetStringUTFChars(env, output_path, 0);
//	int argc = 11; //参数个数
//	char *argv [11];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-f";
//	argv[3] = "concat";
//	argv[4] = "-i";
//	argv[5] = video_list_file_path;
//	argv[6] = "-vcodec";
//	argv[7] = "copy";
//	argv[8] = "-acodec";
//	argv[9] = "copy";
//	argv[10] = output_file_path;
//
//	int ret = main(argc, argv);
//
////	ffmpeg -f concat -i mylist.txt -c copy output.mkv
//
//	(*env)->ReleaseStringUTFChars(env, output_path, output_file_path); //释放输出文件字符串内存
//	(*env)->ReleaseStringUTFChars(env, separator_str, separator);	//释放seperator占用内存
//	(*env)->ReleaseStringUTFChars(env, folder, cache_folder_path); //释放folder占用内存
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    cutVideo
// * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_cutVideo
//  (JNIEnv * env, jclass cls, jstring input_file, jstring start_time, jstring duration, jstring output_file)
//{
//	char const * input_file_path = (*env)->GetStringUTFChars(env, input_file, 0);
//	if(NULL == input_file_path)
//	{
//		return -1; //错误码-1,输入文件为空
//	}
//	char const * output_file_path = (*env)->GetStringUTFChars(env, output_file, 0);
//	if(NULL == output_file_path)
//	{
//		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//		return -2; //错误吗-2,输出文件为空
//	}
//	char const * video_start_time = (*env)->GetStringUTFChars(env, start_time, 0);
//	if(NULL == video_start_time)
//	{
//		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//		(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//		return -3; //错误码-3,开始时间为空
//	}
//	char const * video_duration = (*env)->GetStringUTFChars(env, duration, 0);
//	if(NULL == video_duration)
//	{
//		(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//		(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//		(*env)->ReleaseStringUTFChars(env, video_start_time, start_time);
//		return -4; //错误码-4,开始时间为空
//	}
//
//	LOGI("%s %s", "Input file:", input_file_path);
//	LOGI("%s %s", "Output file:", output_file_path);
//	LOGI("%s %s", "Startt time:", video_start_time);
//	LOGI("%s %s", "Duration:", video_duration);
//
//	int argc = 13;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_file_path;
//	argv[4] = "-ss";
//	argv[5] = video_start_time;
//	argv[6] = "-t";
//	argv[7] = video_duration;
//	argv[8] = "-vcodec";
//	argv[9] = "copy";
//	argv[10] = "-acodec";
//	argv[11] = "copy";
//	argv[12] = output_file_path;
//
//	LOGI("%s %s %s %s %s %s %s %s %s %s %s %s %s", argv[0], argv[1], argv[2], argv[3], argv[4],
//			argv[5], argv[6], argv[7], argv[8], argv[9], argv[10], argv[11], argv[12]);
//
//
//	int ret = main(argc, argv);
//
//	LOGI("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
//
////	ffmpeg -i input.mp4 -ss **START_TIME** -t **STOP_TIME** -acodec copy -vcodec copy output.mp4
////	其中 START_TIME/STOP_TIME 的格式可以写成两种格式：
////
////	以秒为单位计数： 80
////	时:分:秒： 00:01:20
//
//	(*env)->ReleaseStringUTFChars(env, input_file, input_file_path);
//	(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//	(*env)->ReleaseStringUTFChars(env, start_time, video_start_time);
//	(*env)->ReleaseStringUTFChars(env, duration, video_duration);
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    addWaterMark
// * Signature: (Ljava/lang/String;Ljava/lang/String;III)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_addWaterMark
//  (JNIEnv * env, jclass cls, jstring video_file, jstring image_file, jint position, jstring x, jstring y, jstring output_file, jstring format)
//{
//	LOGI("%s %d", "Postion:", position);
//	char const *video_file_path = (*env)->GetStringUTFChars(env, video_file, 0);
//	if(NULL == video_file_path)
//	{
//		return -1; //错误码-1,输入视频文件为空
//	}
//	LOGI("%s %s", "Video file:", video_file_path);
//	char const *image_file_path = (*env)->GetStringUTFChars(env, image_file, 0);
//	if(NULL == image_file_path)
//	{
//		(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
//		return -2; //错误码-2,输出图片文件为空
//	}
//	char const *output_file_path = (*env)->GetStringUTFChars(env, output_file, 0);
//	if(NULL == output_file_path)
//	{
//		(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
//		(*env)->ReleaseStringUTFChars(env, image_file, image_file_path);
//		return -3; //错误码-3,输出文件为空
//	}
//	LOGI("%s %s", "Image file:", image_file_path);
//	char const * output_format = (*env)->GetStringUTFChars(env, format, 0);
//
//
//	char const * x_offset = (*env)->GetStringUTFChars(env, x, 0);
//	char const * y_offset = (*env)->GetStringUTFChars(env, y, 0);
//	if(NULL == x_offset)
//	{
//		x_offset = "0";
//	}
//	if(NULL == y_offset)
//	{
//		y_offset = "0";
//	}
//
//	char * overlay = "overlay";
//	char *water_mark_position;
//	char *position_mid = "overlay=(W-w)/2:(H-h)/2";
//	switch (position) {
//		case 0: //中间
//			water_mark_position = "overlay=(W-w)/2:(H-h)/2";
//			break;
//		case 1: //左上角
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 2);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, ":");
//			strcat(water_mark_position, y_offset);
////			char * video_list_file_path = malloc(strlen(cache_folder_path) + strlen(video_list_file_name) + need_separator + 1);
////				strcpy(video_list_file_path, cache_folder_path);
//			break;
//		case 2: //右上角
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 8);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, "(W-w-");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, "):");
//			strcat(water_mark_position, y_offset);
//			break;
//		case 3:
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 8);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, ":(H-h-");
//			strcat(water_mark_position, y_offset);
//			strcat(water_mark_position, ")");
//			break;
//		case 4:
//			water_mark_position = malloc(strlen(overlay) + strlen(x_offset) + strlen(y_offset) + 13);
//			strcpy(water_mark_position, overlay);
//			strcat(water_mark_position, "=");
//			strcat(water_mark_position, "(W-w-");
//			strcat(water_mark_position, x_offset);
//			strcat(water_mark_position, "):(H-h-");
//			strcat(water_mark_position, y_offset);
//			strcat(water_mark_position, ")");
//			break;
//		default:
//			water_mark_position = NULL;
//			break;
//	}
//
//	if(NULL == water_mark_position) {
//		return -4; //错误码-4,输入的水印位置错误
//	}
//
//	LOGI("Watermark position: %d : %s", position, water_mark_position);
//
//	int argc = 21;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
////	argv[3] = "/sdcard/DCIM/Camera/VID_19700110_122102.3gp";
////	argv[3] = "/mnt/sdcard/DCIM/Camera/VID_20140708_205441.mp4";
//	argv[3] = video_file_path;
//	argv[4] = "-i";
////	argv[5] = "/sdcard/DCIM/Camera/photo.png";
////	argv[5] = "/mnt/sdcard/fb.png";
//	argv[5] = image_file_path;
//	argv[6] = "-filter_complex";
////	argv[7] = "overlay=(W-w)/2:(H-h)/2";
//	argv[7] = water_mark_position;
//	argv[8] = "-c:v";
//	argv[9] = "mpeg4";
//	argv[10] = "-c:a";
//	argv[11] = "copy";
//	argv[12] = "-c:s";
//	argv[13] = "copy";
//	argv[14] = "-b:v";
//	argv[15] = "1000k";
//	argv[16] = "-s";
//	argv[17] = "480x480";
//	argv[18] = "-f";
//	argv[19] = "mp4";
////	argv[20] = "/mnt/sdcard/DCIM/Camera/VID_20140708_205441_watermark.mp4";
//	argv[20] = output_file_path;
////	ffmpeg [-y] -i **VIDEO_INPUT** -i **IMAGE_INPUT** -filter_complex 'overlay=**x**:**y**'
////	-c:v **VIDEO_CODEC** -c:a copy -c:s copy -b:v **VIDEO_BITRATE** -s **VIDEO_SIZE** -f **OUTPUT_FORMAT** **VIDEO_OUTPUT**
//
//	int ret = main(argc, argv);
//
//
//	(*env)->ReleaseStringUTFChars(env, video_file, video_file_path);
//	(*env)->ReleaseStringUTFChars(env, image_file, image_file_path);
//	(*env)->ReleaseStringUTFChars(env, output_file, output_file_path);
//	(*env)->ReleaseStringUTFChars(env, format, output_format);
//	(*env)->ReleaseStringUTFChars(env, x, x_offset);
//	(*env)->ReleaseStringUTFChars(env, y, y_offset);
//	return ret;
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    removeAudio
// * Signature: (Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_removeAudio
//  (JNIEnv * env, jclass cls, jstring input, jstring output)
//{
//	char const *input_video_path = (*env)->GetStringUTFChars(env, input, 0);
//	if(NULL == input_video_path) {
//		return -1;
//	}
//	char const *output_video_path = (*env)->GetStringUTFChars(env, output, 0);
//	if(NULL == output_video_path) {
//		(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//		return -2;
//	}
//
//	int argc =8;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_video_path;
//	argv[4] = "-vcodec";
//	argv[5] = "copy";
//	argv[6] = "-an";
//	argv[7] = output_video_path;
//
//	int ret = main(argc, argv);
//
//	//ffmpeg -i 1.avi -vcodec copy -an 2.avi
//	(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//	(*env)->ReleaseStringUTFChars(env, output, output_video_path);
//	return ret;
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    fetchAudio
// * Signature: (Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_fetchAudio
//  (JNIEnv * env, jclass cls, jstring input, jstring output, jstring format)
//{
//	char const *input_video_path = (*env)->GetStringUTFChars(env, input, 0);
//	if(NULL == input_video_path) {
//		return -1;
//	}
//	char const *output_audio_path = (*env)->GetStringUTFChars(env, output, 0);
//	if(NULL == output_audio_path) {
//		(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//		return -2;
//	}
//	char const *audio_format = (*env)->GetStringUTFChars(env, format, 0);
//
//	int argc = 8;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_video_path;
//	argv[4] = "-f";
//	if(NULL == audio_format) {
//		argv[5] = "wav";
//	} else {
//		argv[5] = audio_format;
//	}
//	argv[6] = "-vn";
//	argv[7] = output_audio_path;
//
//		LOGW("%s %s %s %s %s %s %s %s",
//				argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7]);
//
//	int ret = main(argc, argv);
//
////	ffmpeg -i src.avi -f wav -vn -y dest1.wav
//
//	(*env)->ReleaseStringUTFChars(env, input, input_video_path);
//	(*env)->ReleaseStringUTFChars(env, output, output_audio_path);
//	(*env)->ReleaseStringUTFChars(env, format, audio_format);
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    addAudio
// * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_addAudio
//  (JNIEnv * env, jclass cls, jstring video, jstring audio, jstring output, jstring format)
//{
//	char const *input_video_path = (*env)->GetStringUTFChars(env, video, 0);
//	if(NULL == input_video_path) {
//		return -1;
//	}
//	char const *input_audio_path = (*env)->GetStringUTFChars(env, audio, 0);
//	if(NULL == input_audio_path) {
//		(*env)->ReleaseStringUTFChars(env, video, input_video_path);
//		return -2;
//	}
//	char const *output_video_path = (*env)->GetStringUTFChars(env, output, 0);
//	if(NULL == output_video_path) {
//		(*env)->ReleaseStringUTFChars(env, video, input_video_path);
//		(*env)->ReleaseStringUTFChars(env, audio, input_audio_path);
//		return -3;
//	}
//
//	char const *output_format = (*env)->GetStringUTFChars(env, format, 0);
//
//	int argc = 21;
//	char *argv[argc];
//	argv[0] = "ffmpeg";
//	argv[1] = "-y";
//	argv[2] = "-i";
//	argv[3] = input_video_path;
//	argv[4] = "-i";
//	argv[5] = input_audio_path;
//	argv[6] = "-c:v";
//	argv[7] = "mpeg4";
//	argv[8] = "-c:a";
//	argv[9] = "ac3";
//	argv[10] = "-c:s";
//	argv[11] = "copy";
//	argv[12] = "-b:v";
//	argv[13] = "1000k";
//	argv[14] = "-b:a";
//	argv[15] = "128k";
////	argv[16] = "-s";
////	argv[17] = "640x480";
//	argv[16] = "-ac";
//	argv[17] = "1";
//	argv[18] = "-f";
//	argv[19] = "mp4";
//	argv[20] = "/sdcard/DCIM/Camera/add_audio_out.mp4";
////	argv[20] = output_video_path;
//		LOGW("%s %s %s %s %s %s %s %s %s",
//				argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8]);
//
////		argv[8] = "-c:v";
////			argv[9] = "mpeg4";
////			argv[10] = "-c:a";
////			argv[11] = "copy";
////			argv[12] = "-c:s";
////			argv[13] = "copy";
////			argv[14] = "-b:v";
////			argv[15] = "1000k";
////			argv[16] = "-s";
////			argv[17] = "640x480";
////			argv[18] = "-f";
////			argv[19] = "3gp";
////			argv[20] = "/sdcard/DCIM/Camera/watermark_out.3gp";
//
//	int ret = main(argc, argv);
//
////	ffmpeg -i **INPUT_AUDIO** -i **INPUT_VIDEO** **OUTPUT_VIDEO**
//	(*env)->ReleaseStringUTFChars(env, video, input_video_path);
//	(*env)->ReleaseStringUTFChars(env, audio, input_audio_path);
//	(*env)->ReleaseStringUTFChars(env, output, output_video_path);
//	(*env)->ReleaseStringUTFChars(env, format, output_format);
//
//	return ret;
//}
//
///*
// * Class:     com_opensource_camcorder_utils_FFmpegTool
// * Method:    ffmpeg
// * Signature: (I[Ljava/lang/String;)I
// */
//JNIEXPORT jint JNICALL Java_com_opensource_camcorder_utils_FFmpegTool_ffmpeg
//  (JNIEnv * env, jclass cls, jobjectArray args) {
//	int argc = (*env)->GetArrayLength(env, args);
//	char *argv[argc];
//	int i = 0;
//	for(i = 0; i < argc; i++) { //循环将传入的文件写入清单列表中
//			jstring str = (*env)->GetObjectArrayElement(env, args, i);
//			char const * arg = (*env)->GetStringUTFChars(env, str, 0);
//			argv[i] = arg;
//	}
//	return main(argc, argv);
//}
