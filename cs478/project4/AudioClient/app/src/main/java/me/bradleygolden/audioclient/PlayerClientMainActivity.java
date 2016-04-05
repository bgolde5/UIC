package me.bradleygolden.audioclient;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.Image;
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

    private ImageButton playBtn;
    private ImageButton pauseBtn;
    private ImageButton prevBtn;
    private ImageButton nextBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_player_client_main);

        // Configure play button
        playBtn = (ImageButton)findViewById(R.id.playBtn);
        playBtn.setOnClickListener(playListener);

        // Configure pause button
        pauseBtn = (ImageButton)findViewById(R.id.pauseBtn);
        pauseBtn.setOnClickListener(pauseListener);

        //Configure prev button
        prevBtn = (ImageButton)findViewById(R.id.skipPrevBtn);
        prevBtn.setOnClickListener(prevListener);

        // Configure next button
        nextBtn = (ImageButton)findViewById(R.id.skipNextBtn);
        nextBtn.setOnClickListener(nextListener);
    }

    // Play button listener
    View.OnClickListener playListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(mIsBound){
                try {
                    mIAudioService.playClip("Ocean Motion");

                    // Hide the play button, show the pause button
                    playBtn.setVisibility(View.INVISIBLE);
                    pauseBtn.setVisibility(View.VISIBLE);

                    Log.e(TAG, "Playing song");
                } catch (Exception e){
                    e.printStackTrace();
                }
            }
        }
    };

//    // Pause button listener
    View.OnClickListener pauseListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(mIsBound){
                try {
                    mIAudioService.pauseClip();

                    // Hide the pause button, show the play button
                    pauseBtn.setVisibility(View.INVISIBLE);
                    playBtn.setVisibility(View.VISIBLE);

                    Log.e(TAG, "Pausing song");
                } catch (Exception e){
                    e.printStackTrace();
                }
            }
        }
    };

    // Previous button listener
    View.OnClickListener prevListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(mIsBound){
                try {
                    // If the song is playing, stop it first before going to the previous song
                    if(mIAudioService.isPlaying()){
                        mIAudioService.stopClip();
                        pauseBtn.setVisibility(View.INVISIBLE);
                        playBtn.setVisibility(View.VISIBLE);
                    } else {
                        // TODO Implement go to previous song
                    }

                } catch (Exception e){
                    e.printStackTrace();
                }
            }
        }
    };

    // Next button listener
    View.OnClickListener nextListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(mIsBound){
                try {
                    // If the song is playing, skip to the next one regardless
                    // TODO Implement go to next song
                } catch (Exception e){
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

    @Override
    protected void onStop() {
        super.onStop();

        if(mIsBound) {
            unbindService(mConnection);
            mIsBound = false;
        }
    }

    ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mIAudioService = IAudioService.Stub.asInterface(service);


            if (mIAudioService == null) {
                Log.e(TAG, "Service not connected");

            } else {
                Log.e(TAG, "Service connected");
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mIAudioService = null;
        }
    };
}
