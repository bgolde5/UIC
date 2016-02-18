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
        addSong("Mannish Boy",
                "Muddy Waters",
                "https://www.youtube.com/watch?v=w5IOou6qN1o",
                "https://en.wikipedia.org/wiki/Mannish_Boy",
                "https://en.wikipedia.org/wiki/Muddy_Waters",
                R.drawable.mannish_boy);

        addSong("Kind of Blue",
                "Miles Davis",
                "https://www.youtube.com/watch?v=kbxtYqA6ypM",
                "https://en.wikipedia.org/wiki/Kind_of_Blue",
                "https://en.wikipedia.org/wiki/Miles_Davis",
                R.drawable.kind_of_blue);

        addSong("What a Wonderful World",
                "Louis Armstrong",
                "https://www.youtube.com/watch?v=gDrzKBF6gDU",
                "https://en.wikipedia.org/wiki/What_a_Wonderful_World",
                "https://en.wikipedia.org/wiki/Louis_Armstrong",
                R.drawable.what_a_wonderful_world);

        addSong("Juke",
                "Little Walter",
                "https://www.youtube.com/watch?v=n2vKlQm0QOU",
                "https://en.wikipedia.org/wiki/Juke_(song)",
                "https://en.wikipedia.org/wiki/Little_Walter",
                R.drawable.little_walters_jump);

        addSong("Damn Right I Got the Blues",
                "Buddy Guy",
                "https://www.youtube.com/watch?v=NU5xA6ty0a4",
                "https://en.wikipedia.org/wiki/Damn_Right,_I%27ve_Got_the_Blues",
                "https://en.wikipedia.org/wiki/Buddy_Guy",
                R.drawable.damn_right_i_got_the_blues);

        addSong("One O'Clock Jump",
                "Count Basie",
                "https://www.youtube.com/watch?v=08jyOwx96Ig",
                "https://en.wikipedia.org/wiki/One_O%27Clock_Jump",
                "https://en.wikipedia.org/wiki/Count_Basie",
                R.drawable.show_of_the_week);
    }

    private static void addSong(String songName, String artistName,
                                String youtubeUrl, String songWikiUrl, String artistWikiUrl, Integer imageId) {

        songList.add(new Song(songName, artistName, youtubeUrl, songWikiUrl, artistWikiUrl, imageId));

    }
}
