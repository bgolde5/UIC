package me.bradleygolden.Services.AudioService;

import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;

import me.bradleygolden.Services.AudioService.IAudioService;

/**
 * Created by bradleygolden on 3/31/16.
 */
public class AudioService extends Service {

    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    private final IAudioService.Stub mBinder = new IAudioService.Stub() {

        @Override
        public String playClip(String clip) {
            return "playClip";
        }

        @Override
        public String pauseClip(String clip) throws RemoteException {
            return "pauseClip";
        }

        @Override
        public String stopClip(String clip) throws RemoteException {
            return "stopClip";
        }

        @Override
        public String resumeClip(String clip) throws RemoteException {
            return "resumeClip";
        }
    };
}
