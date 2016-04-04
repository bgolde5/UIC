package me.bradleygolden.PlayerClient;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by bradleygolden on 4/2/16.
 */
public class SongProvider {
    public static List<Song> songList = new ArrayList<>();

    static {
        addSong("Ocean Motion", "Brandon Musser", 0, R.drawable.ocean_motion);
        addSong("Ave Maria", "Nicholas York", 1, R.drawable.ave_maria);
        addSong("Chanson", "Chitose Okashiro", 2, R.drawable.chanson);
        addSong("Ocean Motion", "Brandon Musser", 3, R.drawable.ocean_motion);
        addSong("Ave Maria", "Nicholas York", 4, R.drawable.ave_maria);
        addSong("Chanson", "Chitose Okashiro", 5, R.drawable.chanson);
        addSong("Ocean Motion", "Brandon Musser", 6, R.drawable.ocean_motion);
        addSong("Ave Maria", "Nicholas York", 7, R.drawable.ave_maria);
        addSong("Chanson", "Chitose Okashiro", 8, R.drawable.chanson);
    }

    private static void addSong(String songName, String artistName, int songNumber, int imageId) {
        songList.add(new Song(songName, artistName, songNumber, imageId));
    }
}
