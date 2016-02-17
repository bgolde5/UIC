package me.bradleygolden.project2;

/**
 * Created by bradleygolden on 2/16/16.
 */
public class Song {
    private String songName;
    private String wikiUrl;
    private String artistName;

    public String getSongName() { return songName; }

    public String getWikiUrl() { return wikiUrl; }

    public String getArtistName() { return artistName; }

    public Song (String songName, String wikiUrl, String artistName) {
        this.songName = songName;
        this.wikiUrl = wikiUrl;
        this.artistName = artistName;
    }
}