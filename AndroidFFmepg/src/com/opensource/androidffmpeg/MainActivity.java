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
import android.view.View.OnClickListener;

import com.opensource.androidffmpeg.utils.FFmpegService;
import com.opensource.androidffmpeg.utils.FFmpegTool;
import com.opensource.androidffmpeg.utils.IFFmpegService;

/**
 * Usage 
 * 
 * @author yinglovezhuzhu@gmail.com
 */
public class MainActivity extends Activity implements OnClickListener {
	private static final String TAG = "MainActivity";

	static {
		FFmpegTool.testLog();
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_main);
		
		findViewById(R.id.btn_test).setOnClickListener(this);
		findViewById(R.id.btn_merge).setOnClickListener(this);
		findViewById(R.id.btn_cut).setOnClickListener(this);
		findViewById(R.id.btn_water).setOnClickListener(this);
		findViewById(R.id.btn_remove_audio).setOnClickListener(this);
		findViewById(R.id.btn_fetch_audio).setOnClickListener(this);
		findViewById(R.id.btn_add_audio).setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		Intent intent = new Intent(MainActivity.this, FFmpegService.class);
		intent.putExtra("AAA", "BBBB");
		switch (v.getId()) {
		case R.id.btn_test:
			FFmpegTool.testLog();
			break;
		case R.id.btn_merge:
//			Log.i(TAG, "Merge Video Result: " + FFmpegTool.mergeVideo("/storage/extSdCard/", 
//					"/storage/extSdCard/merge_out.mp4", 
//					"/storage/extSdCard/DCIM/Camera/20140709_180929.mp4", "/storage/extSdCard/DCIM/Camera/20140709_180944.mp4"));
//			Log.i(TAG, "Merge Video Result: " + FFmpegTool.mergeVideo("/sdcard/DCIM/Camera/", 
//					"/sdcard/DCIM/Camera/merge_out.3gp", 
//					"/sdcard/DCIM/Camera/VID_20140709_171222.3gp", "/sdcard/DCIM/Camera/VID_20140709_171239.3gp"));
			bindService(intent, new LocalServiceConnection(0), Service.BIND_AUTO_CREATE);
			
			break;
		case R.id.btn_cut:
			bindService(intent, new LocalServiceConnection(1), Service.BIND_AUTO_CREATE);
			break;
		case R.id.btn_water:
			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_WATERMARK), Service.BIND_AUTO_CREATE);
			break;
		case R.id.btn_remove_audio:
			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_REMOVE_AUDIO), Service.BIND_AUTO_CREATE);
			break;
		case R.id.btn_fetch_audio:
			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_FETCH_AUDIO), Service.BIND_AUTO_CREATE);
			break;
		case R.id.btn_add_audio:
			bindService(intent, new LocalServiceConnection(FFmpegService.CMD_ADD_AUDIO), Service.BIND_AUTO_CREATE);
			break;
		default:
			break;
		}
	}
	
	private IFFmpegService mService;
	
	private final class LocalServiceConnection implements ServiceConnection {
		
		private int mmCommand;
		
		private LocalServiceConnection(int command) {
			this.mmCommand = command;
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
					int ret = mService.addWaterMark("/mnt/sdcard/DCIM/Camera/merge_out.mp4", 
							"/mnt/sdcard/logo.png", 4, 10, 10, "/mnt/sdcard/DCIM/Camera/VID_20140704_103157_watermark_out.mp4", "mp4");
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
