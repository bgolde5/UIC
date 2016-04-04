package me.bradleygolden.PlayerClient;

/**
 * Created by bradleygolden on 4/2/16.
 */
public class Song {

    private String songName;
    private String artistName;
    private int songNumber;
    private int songImage;
    private int songResId;

    public Song(String songName, String artistName, int songNumber, int songImage) {
        this.songName = songName;
        this.artistName = artistName;
        this.songNumber = songNumber;
        this.songImage = songImage;
    }

    public String getArtistName() {
        return artistName;
    }

    public int getSongNumber() {
        return songNumber;
    }

    public int getSongImage() {
        return songImage;
    }

    public String getSongName() {
        return songName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public void setSongName(String songName) {
        this.songName = songName;
    }

    public void setSongNumber(int songNumber) {
        this.songNumber = songNumber;
    }

    public void setSongImage(int songImage) {
        this.songImage = songImage;
    }
}
