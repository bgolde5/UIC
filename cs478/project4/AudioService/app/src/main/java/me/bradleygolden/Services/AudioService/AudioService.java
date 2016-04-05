package me.bradleygolden.Services.AudioService;

import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;

import me.bradleygolden.Services.AudioService.IAudioService;

/**
 * Created by bradleygolden on 3/31/16.
 */
public class AudioService extends Service {

    protected static final String TAG = "AudioServiceServer";
    private MediaPlayer mediaPlayer = null;

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    private final IAudioService.Stub mBinder = new IAudioService.Stub() {

        public void playClip(String clip) {

            if (mediaPlayer == null) {
                // Create a media player with selected song
                // This gets called when a song gets called when a song gets started for the
                // first time or after a song was stopped
                try {
                    mediaPlayer = MediaPlayer.create(getApplicationContext(), ClipMapping.getResID(clip));
                    mediaPlayer.start();
                } catch (Exception e) {
                    Log.e(TAG, e.getStackTrace().toString());
                }

            } else {
                // The song has been paused and will resume
                try {
                    mediaPlayer.start();
                } catch (Exception e) {
                    Log.e(TAG, e.getStackTrace().toString());
                }
            }
        }

        public void pauseClip() {
            mediaPlayer.pause();
        }

        public void stopClip() {
            mediaPlayer.release();
            mediaPlayer = null;
        }

        public void resumeClip() {
            mediaPlayer.start();
        }

        public boolean isPlaying() {
            return mediaPlayer.isPlaying();
        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();

        mediaPlayer.release();
        mediaPlayer = null;
    }
}
