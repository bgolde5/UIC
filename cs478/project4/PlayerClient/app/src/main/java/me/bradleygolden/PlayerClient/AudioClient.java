package me.bradleygolden.PlayerClient;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;

import me.bradleygolden.Services.AudioService.IAudioService;

public class AudioClient extends Activity {

    protected static final String TAG = "AudioServiceUser";
    private IAudioService mAudioService;
    private boolean mIsBound = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_audio_client);

        if(!mIsBound) {
            Intent i = new Intent();
            i.setClassName("me.bradleygolden.Services.AudioService", me.bradleygolden.Services.AudioService.IAudioService.class.getName());
            Boolean b = bindService(i, mConnection, Context.BIND_AUTO_CREATE);

            if (b) {
                Log.e(TAG, "Bound service");
            }
            else {
                Log.e(TAG, "Service not bound");
            }
        }

        final Button playClipBtn = (Button)findViewById(R.id.playClipBtn);

        playClipBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (mIsBound) {
                    TextView playClipTxt = (TextView) findViewById(R.id.playClipTxt);
                    try {
                        playClipTxt.setText(mAudioService.playClip("Test"));
                    } catch (Exception e) {
                        playClipTxt.setText(e.toString());
                        Log.e(TAG, e.toString());
                    }
                }
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onStop() {
        super.onStop();

        // Unbind from the service
        if (mIsBound) {
//            unbindService(mConnection);
            mIsBound = false;
        }
    }

    private final ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mAudioService = IAudioService.Stub.asInterface(service);
            mIsBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mAudioService = null;
            mIsBound = false;

        }
    };
}
