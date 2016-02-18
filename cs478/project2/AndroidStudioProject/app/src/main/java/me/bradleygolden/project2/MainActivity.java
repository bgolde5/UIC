package me.bradleygolden.project2;

import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    private List<Song> songs = DataProvider.songList;

    private static class ContextMenuOptions {
        static Integer WATCH_VIDEO = 0;
        static Integer SONG_WIKI = 1;
        static Integer ARTIST_WIKI = 2;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        SongListAdapter adapter = new SongListAdapter(this, R.layout.list_items, songs);

        ListView listView = (ListView) findViewById(R.id.listView);
        registerForContextMenu(listView);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Song song = songs.get(position);
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(song.getYoutubeUrl()));
                startActivity(intent);
            }
        });
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {

        Song song = (Song)songs.get(item.getGroupId());
        Integer selectedOption = (Integer)item.getItemId();

        Intent intent = new Intent(Intent.ACTION_VIEW);

        if (selectedOption == ContextMenuOptions.WATCH_VIDEO) {
            intent.setData(Uri.parse(song.getYoutubeUrl()));
        }
        else if (selectedOption == ContextMenuOptions.ARTIST_WIKI) {
            intent.setData(Uri.parse(song.getArtistWikiUrl()));
        }
        else if (selectedOption == ContextMenuOptions.SONG_WIKI) {
            intent.setData(Uri.parse(song.getSongWikiUrl()));
        }
        else {
            // some error has occured at this point
            return true;
        }

        startActivity(intent);

        return true;
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
        ListView listView = (ListView)v;
        AdapterView.AdapterContextMenuInfo contextMenuInfo = (AdapterView.AdapterContextMenuInfo) menuInfo;
        Song song = (Song) listView.getItemAtPosition(contextMenuInfo.position);

        menu.add(contextMenuInfo.position, ContextMenuOptions.WATCH_VIDEO, 0, "Watch Video");
        menu.add(contextMenuInfo.position, ContextMenuOptions.SONG_WIKI, 0, "View Song Wiki");
        menu.add(contextMenuInfo.position, ContextMenuOptions.ARTIST_WIKI, 0, "View Artist Wiki");
    }
}
