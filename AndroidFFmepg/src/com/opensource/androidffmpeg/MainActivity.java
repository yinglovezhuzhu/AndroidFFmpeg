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
					args = new String [] {};
					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
					break;
				case 2:
					args = new String [] {"ffmpeg", "-ss", "00:00:00", "-t", "00:00:10", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", 
							"-acodec", "copy", "-vcodec", "copy", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_cut.mp4"};
					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
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
					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
					
					break;
				case 4:
//					args = new String [] {"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", 
//							"-s", "854x480", "-f", "mp4", "-an","/mnt/sdcard/DCIM/Camera/VID_20140811_180204_no_audio.mp4"};
					args = new String [] {"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-map", "0:v", 
							"-f", "mp4", 
							"/mnt/sdcard/DCIM/Camera/VID_20140811_180204_no_audio.mp4"};
					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
					break;
				case 5:
//					args = new String [] {"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", 
//							"-f", "wav", "-vn", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_audio.wav"};
					args = new String [] {"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", 
							"-map", "0:a", "-f", "wav", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_audio.wav"};

					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
					break;
				case 6:
//					bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_AUDIO), Service.BIND_AUTO_CREATE);
					
//					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
//							"/mnt/sdcard/music_cut.mp3", "-c:v", "mpeg4", "-c:a", "ac3", "-c:s", "copy", "-b:v", "1024k", 
//							"-b:a", "128k", "-ac", "1", "-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_add_audio.mp4"};
					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-i", 
							"/mnt/sdcard/music_cut.mp3", "-c:v", "mpeg4", "-c:a", "ac3", "-c:s", "copy", "-b:v", "1024k", 
							"-ac", "1", "-f", "mp4", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_add_audio.mp4"};
					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
					break;
				case 7:
//					./ffmpeg -y -i /home/xiaoying/v5.3gp -filter_complex 
//					'colorchannelmixer=rr=.5:rg=.5:rb=.5:ra=.5:gr=.5:gg=.5:gb=.5:ga=.5:br=.5:bg=.5:bb=.5:ba=.5:ar=.5:ag=.5:ab=.5' 
//					-b:v 1280k -f mpeg /home/xiaoying/v5_out.mp4

					args = new String []{"ffmpeg", "-y", "-i", "/mnt/sdcard/DCIM/Camera/VID_20140811_180204.mp4", "-filter_complex", 
							"colorchannelmixer=rr=.5:rg=.5:rb=.5:gr=.5:gg=.5:gb=.5:br=.5:bg=.5:bb=.5", 
							 "-c:v", "mpeg4", "-c:a", "copy", "-b:v", "1024k", "-s", "864x480", "-f", "mp4", 
							 "/mnt/sdcard/DCIM/Camera/VID_20140811_180204_black_white.mp4"};
					bindService(intent, new LocalServiceConnection(args), Service.BIND_AUTO_CREATE);
					break;
				case 8:
					break;
				default:
					break;
				}
			}
		});
		
	}
	
	private IFFmpegService mService;
	
	private final class LocalServiceConnection implements ServiceConnection {
		
		private String [] mmArgs;
		
		private LocalServiceConnection(String ...args) {
			this.mmArgs = args;
		}
		

		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			// TODO Auto-generated method stub
			mService = IFFmpegService.Stub.asInterface(service);
			if(null == mService) {
				Log.e(TAG, "Failed connect to service");
				return;
			}
			try {
				int ret = mService.ffmpeg(mmArgs);
				Log.i(TAG, "FFmpeg result========>>>>>> " + ret);
				unbindService(this);
			} catch (RemoteException e) {
				e.printStackTrace();
			}
		}

		@Override
		public void onServiceDisconnected(ComponentName name) {
			Log.w(TAG, "Remote service disconnect" + name.getClassName());
			mService = null;
		}
		
	}
	
}
