package me.bradleygolden.PlayerClient;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

import me.bradleygolden.Services.AudioService.IAudioService;

public class AudioClientActivity extends Activity {

    protected static final String TAG = "AudioServiceUser";

    // Provides a list of songs with song name, artist name, song number
    private List<Song> songs = SongProvider.songList;

    private IAudioService mAudioService;
    private boolean mIsBound = false;
    private boolean mServiceIsRunning = false;

    private boolean isStopped = true;

    private ImageButton playBtn;
    private ImageButton pauseBtn;
    private ImageButton prevBtn;
    private ImageButton nextBtn;

    private TextView songNameInBar;
    private TextView artistNameInBar;

    private Song selectedSong;

    private SongPlayer songPlayer; // A mock MediaPlayer created by me!

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_audio_client);

        final SongListAdapter songListAdapter = new SongListAdapter(this, R.layout.list_item, songs);
        ListView listView = (ListView)findViewById(R.id.listView);
        listView.setAdapter(songListAdapter);

        playBtn = (ImageButton)findViewById(R.id.playBtn);
        pauseBtn = (ImageButton)findViewById(R.id.pauseBtn);
        prevBtn = (ImageButton)findViewById(R.id.skipPrevBtn);
        nextBtn = (ImageButton)findViewById(R.id.skipNextBtn);
        songNameInBar = (TextView)findViewById(R.id.songNameTxt_bar);
        artistNameInBar = (TextView)findViewById(R.id.artistNameTxt_bar);

        // get the first song by default
        selectedSong = songs.get(0);

        // Init my custom media player
        songPlayer = new SongPlayer();

        // Set listener for selecting songs
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                selectedSong = songs.get(position);
                songListAdapter.setSelectedIndex(position);

                // Hide the play button, show the pause button
                // This simulates a new song beging selected and played
                isStopped = false;

                // Update the SongPlayer with the current state
                // Force the player to play a song, even if one is playing already
                songPlayer.force_play(selectedSong.getSongName());

                updateSongBar();
            }
        });

        // Listener for playing a clip
        playBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                // Show the pause button, hide this button
                isStopped = false;

                // Update the SongPlayer with the current state
                songPlayer.play(selectedSong.getSongName());

                updateSongBar();
            }
        });

        // Listener for pausing a clip
        pauseBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                // Show the play button, hide this button
                isStopped = true;

                // Update the SongPlayer with the current state
                songPlayer.pause();

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

                // Update the selected song index in the gui
                songListAdapter.setSelectedIndex(selectedSong.getSongNumber());

                isStopped = false;

                // Play the next song even if a song is currently playing
                songPlayer.force_play(selectedSong.getSongName());

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

                // If there isn't a song playing, go back in the playlist
                if(isStopped) {

                    // Skipped the very first song, do not go any further
                    if(selectedSong.getSongNumber() <= 0){
                        // Do nothing
                        return;
                    } else {
                        // decrement the selected song by 1
                        selectedSong = songs.get(selectedSong.getSongNumber()-1);
                    }

                    // Update the selected song index in the gui
                    songListAdapter.setSelectedIndex(selectedSong.getSongNumber());

                    // Play the previous song now that the user has pressed back TWICE
                    isStopped = false;
                    songPlayer.play(selectedSong.getSongName());

                } else {
                    // Stop the current song
                    isStopped = true;
                    songPlayer.stop();
                }

                updateSongBar();

            }
        });

        updateSongBar();

    }

    @Override
    protected void onStart() {
        super.onStart();

        if(!mIsBound) {
            boolean b = false;

            // Bind to AudioService
            Intent i = new Intent(IAudioService.class.getName());
            startService(i);
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
            mServiceIsRunning = true;

            // Init my custom media player
            songPlayer.setmPlayer(mAudioService);
        }

        public void onServiceDisconnected(ComponentName name) {
            Log.e(TAG, "Service disconnected");
            mAudioService = null;
            mIsBound = false;
            mServiceIsRunning = false;
        }
    };

    private void updateSongBar(){
        songNameInBar.setText(selectedSong.getSongName());
        artistNameInBar.setText(selectedSong.getArtistName());

        // Set background of the bar to the background of the image
        ImageView imageView = (ImageView)findViewById(R.id.imageView);
        imageView.setImageResource(selectedSong.getSongImage());
        imageView.setColorFilter(Color.rgb(50, 50, 50), android.graphics.PorterDuff.Mode.MULTIPLY);

        // Toggle the play/pause button depending on whether a song is playing or not
        if(isStopped){
            playBtn.setVisibility(View.VISIBLE);
            pauseBtn.setVisibility(View.INVISIBLE);
        } else {
            playBtn.setVisibility(View.INVISIBLE);
            pauseBtn.setVisibility(View.VISIBLE);
        }
    }

    @Override
    protected void onStop() {
        super.onStop();

        Log.e(TAG, "onStop");

        if(mIsBound){
            unbindService(mConnection);
            mIsBound = false;
            Log.e(TAG, "Service unbound");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        Log.e(TAG, "onDestroy");

        if (mIsBound){
            unbindService(mConnection);
            Log.e(TAG, "Service unbound");
        }

        if (mServiceIsRunning) {
            Log.e(TAG, "Service stopped");
            Intent i = new Intent(IAudioService.class.getName());
            stopService(i);
            mServiceIsRunning = false;
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.player_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.history:
                // Load the history activity
                Intent intent = new Intent(this, HistoryActivity.class);
                startActivity(intent);
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }
}
