package me.bradleygolden.audioclient;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

import me.bradleygolden.Services.AudioService.IAudioService;

public class PlayerClientMainActivity extends Activity {

    private final String TAG = PlayerClientMainActivity.class.getName();
    private boolean mIsBound = false;
    private IAudioService mIAudioService;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_player_client_main);

        ImageButton playBtn = (ImageButton)findViewById(R.id.playBtn);
        playBtn.setOnClickListener(playListener);
    }

    View.OnClickListener playListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(mIsBound){
                try {
                    mIAudioService.playClip("Ocean Motion");
                    Log.e(TAG, "Playing song");
                } catch (RemoteException e){
                    e.printStackTrace();
                }
            }
        }
    };

    @Override
    protected void onStart() {
        super.onStart();

        if(!mIsBound) {
            boolean b = false;

            // Bind to AudioService
            Intent i = new Intent(IAudioService.class.getName());
            b = bindService(i, mConnection, Context.BIND_AUTO_CREATE);

            if (b) {
                Log.e(TAG, "Bound service");
                mIsBound = true;
            }
            else {
                Log.e(TAG, "Service not bound");
            }
        }
    }

    ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mIAudioService = IAudioService.Stub.asInterface(service);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mIAudioService = null;
        }
    };
}
