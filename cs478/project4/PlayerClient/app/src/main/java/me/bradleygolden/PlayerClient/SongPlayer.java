package me.bradleygolden.PlayerClient;

import android.util.Log;

import me.bradleygolden.Services.AudioService.IAudioService;

/**
 * Created by bradleygolden on 4/4/16.
 */
public class SongPlayer {

    private IAudioService mPlayer;

    public void setmPlayer(IAudioService mPlayer) {
        this.mPlayer = mPlayer;
    }

    public void play(String songName){
        try {
            mPlayer.playClip(songName);
        } catch (Exception e) {
            Log.e("play", e.toString());
        }
    }

    public void force_play(String songName){
        stop();
        play(songName);
    }

    public void stop(){
        try {
            mPlayer.stopClip();
        } catch (Exception e) {
            Log.e("stop", e.toString());
        }
    }

    public void pause(){
        try {
            mPlayer.pauseClip();
        } catch (Exception e) {
            Log.e("pause", e.toString());
        }
    }

    public void resume(){
        try {
            mPlayer.resumeClip();
        } catch (Exception e) {
            Log.e("resume", e.toString());
        }
    }

}
