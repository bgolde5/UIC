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
    private MediaPlayer mediaPlayer;


    @Override
    public void onCreate() {

    }

    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    private final IAudioService.Stub mBinder = new IAudioService.Stub() {

        public void playClip(String clip) throws RemoteException {

            if (mediaPlayer == null) {
                // Create a media player with selected song
                mediaPlayer = MediaPlayer.create(getApplicationContext(), ClipMapping.getResID(clip));
                mediaPlayer.start();
            } else {
                // User has selected to replay a song, we don't know if that song is currently
                // being played or not so we get the song again and replay if the same or different
                mediaPlayer.release();
                mediaPlayer = MediaPlayer.create(getApplicationContext(), ClipMapping.getResID(clip));
                mediaPlayer.start();
            }
        }

        public void pauseClip() throws RemoteException {
            mediaPlayer.pause();
        }

        public void stopClip() throws RemoteException {
            mediaPlayer.reset();
        }

        public void resumeClip() throws RemoteException {
            mediaPlayer.start();
        }
    };

    @Override
    public void onDestroy() {
        mediaPlayer.release();
        mediaPlayer = null;
        super.onDestroy();
    }
}
