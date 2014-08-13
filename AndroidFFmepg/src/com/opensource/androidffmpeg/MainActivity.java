/*
 * Copyright (C) 2014  The Android Open Source Project.
 *
 *		yinglovezhuzhu@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * 		http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */	
package com.opensource.androidffmpeg;


import android.app.Activity;
import android.app.Service;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.opensource.androidffmpeg.utils.FFmpegService;
import com.opensource.androidffmpeg.utils.FFmpegTool;
import com.opensource.androidffmpeg.utils.IFFmpegService;

/**
 * Usage 
 * 
 * @author yinglovezhuzhu@gmail.com
 */
public class MainActivity extends Activity {
	private static final String TAG = "MainActivity";
	
	private ListView mLv;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_main);
		
		mLv = (ListView) findViewById(R.id.lv_option_list);
		
		String [] array = getResources().getStringArray(R.array.option_list);
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, array);
		mLv.setAdapter(adapter);
		
		mLv.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(MainActivity.this, FFmpegService.class);
				intent.putExtra("AAA", "BBBB");
				String [] args;
				switch (position) {
				case 0:
					FFmpegTool.testLog();
					break;
				case 1:
					bindService(intent, new LocalServiceConnection(0), Service.BIND_AUTO_CREATE);
					break;
				case 2:
					bindService(intent, new LocalServiceConnection(1), Service.BIND_AUTO_CREATE);
					break;
				case 3:
//					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_WATERMARK), Service.BIND_AUTO_CREATE);
					
//					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
//							"/mnt/sdcard/fb.png", "-filter_complex", 
//							"overlay=(W-w)/2:(H-h)/2", "-c:v", "mpeg4", "-c:a", "copy", "-b:v", "1000k", "-s", "864x480", 
//							"-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_watermark.mp4"};
//					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
//							"/mnt/sdcard/fb.png", "-filter_complex", 
//							"overlay=(W-w)/2:(H-h)/2", "-c:v", "mpeg4", "-c:a", "copy", "-b:v", "1000k", "-s", "864x480", 
//							"-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_watermark.mp4"};
//					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-vf", 
//							"movie=/mnt/sdcard/post.png,scale=480x480, rotate=angle=3*PI/2[wm],[in][wm]overlay=(W-w)/2:(H-h)/2, crop=w=480:h=480[out]", "-c:v", "mpeg4", "-c:a", "copy", "-b:v", "1000k", "-s", "864x480", 
//							"-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_watermark.mp4"};
					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
							"/mnt/sdcard/record.png", "-filter_complex", 
							"[1:v]scale=480x480, rotate=3*PI/2[wm];[0:v][wm]overlay=x=(W-w)/2:y=(H-h)/2,crop=x=(in_w-480)/2:y=(in_h-480)/2:w=480:h=480, rotate=PI/2[out]", 
							"-map", "[out]", "-c:v", "mpeg4", "-c:a", "copy", "-b:v", "1000k", "-s", "480x480", 
							"-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_watermark.mp4"};
					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ALL, args), Service.BIND_AUTO_CREATE);
					
					break;
				case 4:
					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_REMOVE_AUDIO), Service.BIND_AUTO_CREATE);
					break;
				case 5:
					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_FETCH_AUDIO), Service.BIND_AUTO_CREATE);
					break;
				case 6:
//					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_AUDIO), Service.BIND_AUTO_CREATE);
					
//					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
//							"/mnt/sdcard/music_cut.mp3", "-c:v", "mpeg4", "-c:a", "ac3", "-c:s", "copy", "-b:v", "1024k", 
//							"-b:a", "128k", "-ac", "1", "-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_add_audio.mp4"};
					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
							"/mnt/sdcard/music_cut.mp3", "-c:v", "mpeg4", "-c:a", "ac3", "-c:s", "copy", "-b:v", "1024k", 
							"-ac", "1", "-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_add_audio.mp4"};
					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ALL, args), Service.BIND_AUTO_CREATE);
					break;
				case 7:
//					./ffmpeg -y -i /home/xiaoying/v5.3gp -filter_complex 
//					'colorchannelmixer=rr=.5:rg=.5:rb=.5:ra=.5:gr=.5:gg=.5:gb=.5:ga=.5:br=.5:bg=.5:bb=.5:ba=.5:ar=.5:ag=.5:ab=.5' 
//					-b:v 1280k -f mpeg /home/xiaoying/v5_out.mp4

					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-filter_complex", 
							"colorchannelmixer=rr=.5:rg=.5:rb=.5:gr=.5:gg=.5:gb=.5:br=.5:bg=.5:bb=.5", 
							 "-c:v", "mpeg4", "-c:a", "copy", "-b:v", "1024k", "-s", "864x480", "-f", "mp4", 
							 "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_black_white.mp4"};
					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ALL, args), Service.BIND_AUTO_CREATE);
					break;
				case 8:
					break;
				default:
					break;
				}
			}
		});
		
	}
	
//	@Override
//	public void onClick(View v) {
//		Intent intent = new Intent(MainActivity.this, FFmpegService.class);
//		intent.putExtra("AAA", "BBBB");
//		switch (v.getId()) {
//		case R.id.btn_test:
//			FFmpegTool.testLog();
//			break;
//		case R.id.btn_merge:
////			Log.i(TAG, "Merge Video Result: " + FFmpegTool.mergeVideo("/storage/extSdCard/", 
////					"/storage/extSdCard/merge_out.mp4", 
////					"/storage/extSdCard/DCIM/Camera/20140709_180929.mp4", "/storage/extSdCard/DCIM/Camera/20140709_180944.mp4"));
////			Log.i(TAG, "Merge Video Result: " + FFmpegTool.mergeVideo("/sdcard/DCIM/Camera/", 
////					"/sdcard/DCIM/Camera/merge_out.3gp", 
////					"/sdcard/DCIM/Camera/VID_20140709_171222.3gp", "/sdcard/DCIM/Camera/VID_20140709_171239.3gp"));
//			bindService(intent, new LocalServiceConnection(0), Service.BIND_AUTO_CREATE);
//			
//			break;
//		case R.id.btn_cut:
//			bindService(intent, new LocalServiceConnection(1), Service.BIND_AUTO_CREATE);
//			break;
//		case R.id.btn_water:
//			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_WATERMARK), Service.BIND_AUTO_CREATE);
//			break;
//		case R.id.btn_remove_audio:
//			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_REMOVE_AUDIO), Service.BIND_AUTO_CREATE);
//			break;
//		case R.id.btn_fetch_audio:
//			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_FETCH_AUDIO), Service.BIND_AUTO_CREATE);
//			break;
//		case R.id.btn_add_audio:
//			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_AUDIO), Service.BIND_AUTO_CREATE);
//			break;
//		default:
//			break;
//		}
//	}
	
	private IFFmpegService mService;
	
	private final class LocalServiceConnection implements ServiceConnection {
		
		private int mmCommand;
		private String [] mmArgs;
		
		private LocalServiceConnection(int command, String ...args) {
			this.mmCommand = command;
			this.mmArgs = args;
		}
		

		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			// TODO Auto-generated method stub
			mService = IFFmpegService.Stub.asInterface(service);
			switch (mmCommand) {
			case FFmpegService.CMD_MERGE_VIDEO:
				try {
//					int ret = mService.mergeVideo("/sdcard/DCIM/Camera/", 
//							"/sdcard/DCIM/Camera/merge_out.3gp", 
//							new String [] {"/sdcard/DCIM/Camera/VID_20140709_171222.3gp", "/sdcard/DCIM/Camera/VID_20140709_171239.3gp"});
//					int ret = mService.mergeVideo("/sdcard/DCIM/Camera/", 
//							"/sdcard/DCIM/Camera/merge_out.3gp", 
//							new String [] {"/sdcard/DCIM/Camera/VID_19700110_122102.3gp", "/sdcard/DCIM/Camera/VID_20140520_181236.3gp"});
//					int ret = mService.mergeVideo("/sdcard/DCIM/Camera/", 
//							"/sdcard/DCIM/Camera/merge_out.3gp", 
//							new String [] {"/sdcard/DCIM/Camera/VID_19700110_122102.3gp", "/sdcard/DCIM/Camera/VID_20140520_181236.3gp"});
					int ret = mService.mergeVideo("/mnt/sdcard/DCIM/Camera/", 
							"/mnt/sdcard/DCIM/Camera/merge_out.mp4", 
							new String [] {"/mnt/sdcard/DCIM/Camera/VID_20140704_103157.mp4", 
							"/mnt/sdcard/DCIM/Camera/VID_20140708_203811.mp4"});
					System.out.println("Merge video result:++>>> " + ret);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				unbindService(this);
				break;
			case FFmpegService.CMD_CUT_VIDEO:
				try {
//					int ret = mService.cutVideo("/sdcard/DCIM/Camera/VID_20140709_171222.3gp", 
//							"/sdcard/DCIM/Camera/cut_out.mp4", "00:00:00", "00:00:03");
					int ret = mService.cutVideo("/sdcard/DCIM/Camera/VID_19700110_122102.3gp", 
							"00:00:00", "00:00:03", "/sdcard/DCIM/Camera/cut_out.3gp");
					System.out.println("Cut video result:++>>> " + ret);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				unbindService(this);
				break;
			case FFmpegService.CMD_ADD_WATERMARK:
				try {
//					int ret = mService.addWaterMark("/sdcard/DCIM/Camera/VID_19700110_122102.3gp", 
//							"/sdcard/fb.png", 0, 10, 10, "/sdcard/DCIM/Camera/watermark_out.mp4", "mp4");
					int ret = mService.addWaterMark("/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", 
							"/mnt/sdcard/fb.png", 4, 10, 10, "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_watermark.mp4", "mp4");
					System.out.println("Add watermark result:++>>> " + ret);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				unbindService(this);
				break;
			case FFmpegService.CMD_REMOVE_AUDIO:
				try {
					int ret = mService.removeAudio("/sdcard/DCIM/Camera/VID_19700110_122102.3gp", "/sdcard/DCIM/Camera/no_auido.3gp");
					System.out.println("Remvoe audio result:++>>> " + ret);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				unbindService(this);
				break;
			case FFmpegService.CMD_FETCH_AUDIO:
				try {
					int ret = mService.fetchAudio("/sdcard/DCIM/Camera/VID_19700110_122102.3gp", "/sdcard/DCIM/Camera/fetch_audio.wav", "wav");
					System.out.println("Fetch audio result:+++>>> " + ret);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				unbindService(this);
				break;
			case FFmpegService.CMD_ADD_AUDIO:
				try {
					int ret = mService.addAudio("/sdcard/DCIM/Camera/VID_19700110_122102.3gp", 
							"/sdcard/music_cut.mp3", "/sdcard/DCIM/Camera/add_audio_out.3gp", "mpeg4");
					System.out.println("Add audio result:+++>>> " + ret);
				} catch (RemoteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				unbindService(this);
				break;
			case FFmpegService.CMD_ALL:
				try {
					int ret = mService.ffmpeg(mmArgs);
					Log.i(TAG, "FFmpeg result========>>>>>> " + ret);
					unbindService(this);
				} catch (RemoteException e) {
					e.printStackTrace();
				}
				break;
			default:
				break;
			}
		}

		@Override
		public void onServiceDisconnected(ComponentName name) {
			Log.w(TAG, "Remote service disconnect" + name.getClassName());
			mService = null;
		}
		
	}
	
}
