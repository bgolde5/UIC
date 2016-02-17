package me.bradleygolden.project2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by bradleygolden on 2/16/16.
 */
public final class DataProvider {

    public static List<Song> songList = new ArrayList<>();
    public static Map<String, Song> songMap = new HashMap<>();

    static {
        addSong("Mannish Boy", "https://en.wikipedia.org/wiki/Mannish_Boy", "Muddy Waters");
    }

    private static void addSong(String songName, String wikiUrl, String artistName) {
        songList.add(new Song(songName, wikiUrl, artistName));
    }
}
