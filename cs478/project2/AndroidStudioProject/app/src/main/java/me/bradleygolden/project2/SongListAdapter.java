package me.bradleygolden.project2;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.media.Image;
import android.support.v7.widget.AppCompatDrawableManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

/**
 * Created by bradleygolden on 2/18/16.
 */
public class SongListAdapter extends ArrayAdapter<Song> {

    private List<Song> songs;

    public SongListAdapter(Context context, int resource, List<Song> objects) {
        super(context, resource, objects);
        songs = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).
                    inflate(R.layout.list_items, parent, false);
        }

        Song song = songs.get(position);

        TextView songText = (TextView)convertView.findViewById(R.id.songText);
        songText.setText(song.getSongName());

        TextView artistText = (TextView)convertView.findViewById(R.id.artistText);
        artistText.setText(song.getArtistName());

        ImageView songImage = (ImageView)convertView.findViewById(R.id.songImage);
        songImage.setImageResource(song.getImageId());

        return convertView;
    }
}
