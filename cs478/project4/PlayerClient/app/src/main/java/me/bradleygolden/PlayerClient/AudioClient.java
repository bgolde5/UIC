package me.bradleygolden.PlayerClient;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import me.bradleygolden.Services.AudioService.IAudioService;

public class AudioClient extends Activity {

    protected static final String TAG = "AudioServiceUser";
    private IAudioService mAudioService;
    private boolean mIsBound = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_audio_client);

        final TextView clipName = (TextView)findViewById(R.id.clipTxt);
        final Button playClipBtn = (Button)findViewById(R.id.playClipBtn);
        final Button pauseClipBtn = (Button)findViewById(R.id.pauseClipBtn);
        final Button stopClipBtn = (Button)findViewById(R.id.stopClipBtn);
        final Button resumeClipBtn = (Button)findViewById(R.id.resumeClipBtn);

        // Listener for playing a clip
        playClipBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                try {
                    if (mIsBound) {
                        mAudioService.playClip(clipName.getText().toString());
                    } else {
                        Log.e(TAG, "Bradley says the service was not bound and can't play!");
                    }
                } catch (RemoteException e){
                    Log.e(TAG, e.toString());
                }
            }
        });

        // Listener for pausing a clip
        pauseClipBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    if (mIsBound) {
                        mAudioService.pauseClip();
                    } else {
                        Log.e(TAG, "Bradley says the service is not bound and can't pause!");
                    }
                } catch (RemoteException e) {
                    Log.e(TAG, e.toString());
                }
            }
        });

        // Listener for stopping a clip
        stopClipBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    if (mIsBound) {
                        mAudioService.stopClip();
                    } else {
                        Log.e(TAG, "Bradley says the service is not bound and can't stop!");
                    }
                } catch (RemoteException e) {
                    Log.e(TAG, e.toString());
                }
            }
        });

        // Listener for resuming a clip
        resumeClipBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    if (mIsBound) {
                        mAudioService.resumeClip();
                    } else {
                        Log.e(TAG, "Bradley says the service is not bound and can't resume!");
                    }
                } catch (RemoteException e) {
                    Log.e(TAG, e.toString());
                }
            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();

        if(!mIsBound) {
            boolean b = false;
            Intent i = new Intent(IAudioService.class.getName());
            b = bindService(i, this.mConnection, Context.BIND_AUTO_CREATE);

            if (b) {
                Log.e(TAG, "Bound service");
            }
            else {
                Log.e(TAG, "Service not bound");
            }
        }
    }

    @Override
    protected void onPause() {

        if(mIsBound){
            unbindService(this.mConnection);
        }

        super.onPause();
    }

    private final ServiceConnection mConnection = new ServiceConnection() {

        public void onServiceConnected(ComponentName name, IBinder service) {
            mAudioService = IAudioService.Stub.asInterface(service);
            mIsBound = true;
        }

        public void onServiceDisconnected(ComponentName name) {
            mAudioService = null;
            mIsBound = false;
        }
    };
}
