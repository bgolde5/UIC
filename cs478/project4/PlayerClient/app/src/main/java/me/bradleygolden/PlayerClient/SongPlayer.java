package me.bradleygolden.PlayerClient;

import android.util.Log;
import java.util.List;

import me.bradleygolden.Services.AudioService.IAudioService;

/**
 * Created by bradleygolden on 4/4/16.
 */
public class SongPlayer {

    private IAudioService mPlayer;
    private List<String> transactions;

    private static SongPlayer instance = null;

    protected SongPlayer() {
        // Exists only to defeat instantiation.
    }

    public static SongPlayer getInstance() {
        if(instance == null) {
            instance = new SongPlayer();
        }
        return instance;
    }

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

    public List<String> getTransactions(){

        if (transactions != null) {
            return transactions;
        }

        try {
            return mPlayer.getTransactions();
        } catch (Exception e) {
            Log.e("getTransactions", e.toString());
            return null;
        }
    }

    public void saveTransactions() {
        try {
            transactions = mPlayer.getTransactions();
        } catch (Exception e) {
            Log.e("loadTransactions", e.toString());
        }
    }

    public void deleteTransactions() {
        try {
            mPlayer.clearTransactions();
        } catch (Exception e) {
            Log.e("deleteTransactions", e.toString());
        }
    }
}
