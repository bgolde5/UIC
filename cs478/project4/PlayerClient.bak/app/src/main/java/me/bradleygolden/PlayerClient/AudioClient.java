package me.bradleygolden.PlayerClient;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.ClipDrawable;
import android.os.Bundle;
import android.os.IBinder;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.util.List;

import me.bradleygolden.Services.AudioService.IAudioService;

public class AudioClient extends Activity {

    protected static final String TAG = "AudioServiceUser";

    // Provides a list of songs with song name, artist name, song number
    private List<Song> songs = SongProvider.songList;

    private IAudioService mAudioService;
    private boolean mIsBound = false;
    private boolean isStopped = true;

    private ImageButton playBtn;
    private ImageButton pauseBtn;
    private ImageButton prevBtn;
    private ImageButton nextBtn;

    private TextView songNameInBar;
    private TextView artistNameInBar;

    private Song selectedSong = songs.get(0);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_audio_client);

//        final SongListAdapter songListAdapter = new SongListAdapter(this, R.layout.list_item, songs);
//        ListView listView = (ListView)findViewById(R.id.listView);
//        listView.setAdapter(songListAdapter);

        playBtn = (ImageButton)findViewById(R.id.playBtn);
        pauseBtn = (ImageButton)findViewById(R.id.pauseBtn);
        prevBtn = (ImageButton)findViewById(R.id.skipPrevBtn);
        nextBtn = (ImageButton)findViewById(R.id.skipNextBtn);
        songNameInBar = (TextView)findViewById(R.id.songNameTxt_bar);
        artistNameInBar = (TextView)findViewById(R.id.artistNameTxt_bar);

//        // Set listener for selecting songs
//        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//            @Override
//            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//                selectedSong = songs.get(position);
//                songListAdapter.setSelectedIndex(position);
//
//                try
//                {
//                    mAudioService.playClip(selectedSong.getSongName());
//                    // Hide the play button, show the pause button
//                    // This simulates a new song beging selected and played
//                    playBtn.setVisibility(View.INVISIBLE);
//                    pauseBtn.setVisibility(View.VISIBLE);
//
//                    isStopped = false;
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//
//                updateSongBar();
//
//            }
//        });

        // Listener for playing a clip
        playBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    if (mIsBound) {
                        // Show the pause button, hide this button
                        playBtn.setVisibility(View.INVISIBLE);
                        pauseBtn.setVisibility(View.VISIBLE);
                        isStopped = false;
                        mAudioService.playClip(selectedSong.getSongName());
                    } else {
                        Log.e(TAG, "Bradley says the service was not bound and can't play!");
                    }
                } catch (Exception e){
                    e.printStackTrace();
                }

                updateSongBar();
            }
        });
//
        // Listener for pausing a clip
        pauseBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    if (mIsBound) {
                        // Show the play button, hide this button
                        playBtn.setVisibility(View.VISIBLE);
                        pauseBtn.setVisibility(View.INVISIBLE);
                        isStopped = true;
//                        mAudioService.pauseClip();
                    } else {
                        Log.e(TAG, "Bradley says the service is not bound and can't pause!");
                    }
                } catch (Exception e) {
                    Log.e(TAG, e.toString());
                }

                updateSongBar();
            }
        });

        // Listener for going to the next clip
        nextBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                // Skipped the very last song, do not go any further
                if(selectedSong.getSongNumber() >= songs.size()-1){
                    // Do nothing
                    return;
                } else {
                    // increment the selected song by 1
                    selectedSong = songs.get(selectedSong.getSongNumber()+1);
                }

//                // Update the selected song index in the gui
//                songListAdapter.setSelectedIndex(selectedSong.getSongNumber());

                try {
//                    mAudioService.playClip(selectedSong.getSongName());
                } catch(Exception e) {
                    Log.e(TAG, "Error, song wasn't skipped to the next one.");
                    e.printStackTrace();
                }

                updateSongBar();
            }
        });

        // Listener for going to the previous song
        // This stops the current song if it's playing
        // and goes to the previous song only if the song
        // is already stopped
        prevBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if(isStopped) {
                    // Skipped the very first song, do not go any further
                    if(selectedSong.getSongNumber() <= 0){
                        // Do nothing
                        return;
                    } else {
                        // decrement the selected song by 1
                        selectedSong = songs.get(selectedSong.getSongNumber()-1);
                    }

//                    // Update the selected song index in the gui
//                    songListAdapter.setSelectedIndex(selectedSong.getSongNumber());

                    try {
//                    mAudioService.playClip(selectedSong.getSongName());
                    } catch(Exception e) {
                        Log.e(TAG, "Error, song wasn't skipped to the previous one.");
                        e.printStackTrace();
                    }
                } else {
                    // Stop the current song
                    pauseBtn.setVisibility(View.INVISIBLE);
                    playBtn.setVisibility(View.VISIBLE);
                    isStopped = true;
                }

                updateSongBar();

            }
        });
//
//        // Listener for stopping a clip
//        stopClipBtn.setOnClickListener(new OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                try {
//                    if (mIsBound) {
//                        mAudioService.stopClip();
//                    } else {
//                        Log.e(TAG, "Bradley says the service is not bound and can't stop!");
//                    }
//                } catch (RemoteException e) {
//                    Log.e(TAG, e.toString());
//                }
//            }
//        });
//
//        // Listener for resuming a clip
//        resumeClipBtn.setOnClickListener(new OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                try {
//                    if (mIsBound) {
//                        mAudioService.resumeClip();
//                    } else {
//                        Log.e(TAG, "Bradley says the service is not bound and can't resume!");
//                    }
//                } catch (RemoteException e) {
//                    Log.e(TAG, e.toString());
//                }
//            }
//        });

        updateSongBar();

    }

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
            }
            else {
                Log.e(TAG, "Service not bound");
            }
        }
    }

    private final ServiceConnection mConnection = new ServiceConnection() {

        public void onServiceConnected(ComponentName name, IBinder service) {
            mAudioService = IAudioService.Stub.asInterface(service);
            Log.e(TAG, "Service connected");
            mIsBound = true;
        }

        public void onServiceDisconnected(ComponentName name) {
            Log.e(TAG, "Service disconnected");
            mAudioService = null;
            mIsBound = false;
        }
    };

    private void updateSongBar(){
        songNameInBar.setText(selectedSong.getSongName());
        artistNameInBar.setText(selectedSong.getArtistName());

        // Set background of the bar to the background of the image
        ImageView imageView = (ImageView)findViewById(R.id.imageView);
        imageView.setImageResource(selectedSong.getSongImage());
        imageView.setColorFilter(Color.rgb(50, 50, 50), android.graphics.PorterDuff.Mode.MULTIPLY);
    }

    @Override
    protected void onStop() {
        super.onStop();

        if(mIsBound) {
            unbindService(mConnection);
        }
    }
}
