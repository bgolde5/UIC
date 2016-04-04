package me.bradleygolden.PlayerClient;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.util.List;

/**
 * Created by bradleygolden on 4/2/16.
 */
public class SongListAdapter extends ArrayAdapter<Song> {

    protected static final String TAG = "SongListAdapter";

    private List<Song> songs;
    private int selectedIndex;

    public SongListAdapter(Context context, int resource, List<Song> objects) {
        super(context, resource, objects);
        songs = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext())
                    .inflate(R.layout.list_item, parent, false);
        }

        Song song = songs.get(position);

        TextView songNameTxt = (TextView)convertView.findViewById(R.id.songNameTxt);
        songNameTxt.setText(song.getSongName());

        TextView artistNameTxt = (TextView)convertView.findViewById(R.id.artistNameTxt);
        artistNameTxt.setText(song.getArtistName());

        TextView songNumberTxt = (TextView)convertView.findViewById(R.id.songNumberTxt);
        songNumberTxt.setText((song.getSongNumber() + 1) + ""); // Adjust the song number index from 1 instead of 0

        ImageView songImage = (ImageView)convertView.findViewById(R.id.songImage);
        songImage.setImageResource(song.getSongImage());


//         Highlight the background of the current selected song
//         All other songs have a transparent background
        if (selectedIndex >= 0 && position == selectedIndex) {
            convertView.setBackgroundColor(Color.CYAN);
        } else {
            convertView.setBackgroundColor(Color.TRANSPARENT);
        }

        return convertView;
    }

    // Track the selected index to keep the current view highlighted
    // This makes it easy for the user to see which song they are currently playing
    public void setSelectedIndex(int index){
        this.selectedIndex = index;
        notifyDataSetChanged();
    }
}
