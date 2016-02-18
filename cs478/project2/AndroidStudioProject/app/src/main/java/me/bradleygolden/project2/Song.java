package me.bradleygolden.project2;

import android.graphics.drawable.Drawable;

/**
 * Created by bradleygolden on 2/16/16.
 */
public class Song {
    private String songName;
    private String songWikiUrl;
    private String artistWikiUrl;
    private String artistName;
    private String youtubeUrl;
    private Integer imageId;

    public String getSongName() { return songName; }

    public String getSongWikiUrl() { return songWikiUrl; }

    public String getArtistWikiUrl() { return artistWikiUrl; }

    public String getArtistName() { return artistName; }

    public String getYoutubeUrl () { return youtubeUrl; }

    public Integer getImageId () { return imageId; }

    public Song (String songName, String artistName, String youtubeUrl,
                 String songWikiUrl, String artistWikiUrl, Integer imageId) {
        this.songName = songName;
        this.artistName = artistName;
        this.songWikiUrl = songWikiUrl;
        this.artistWikiUrl = artistWikiUrl;
        this.youtubeUrl = youtubeUrl;
        this.imageId = imageId;
    }
}