package me.bradleygolden.project2;

import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    public void playVideo() {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("https://www.youtube.com/watch?v=gBUTbHHH3I8"));
        startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        Button watchVideoButton = (Button)findViewById(R.id.watchVideoButton);
//        watchVideoButton.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                playVideo();
//            }
//        });

//        String[] items = getResources().getStringArray(R.array.music);
//        ArrayAdapter<String> adapter = new ArrayAdapter<String>(
//                this,
//                android.R.layout.,
//                android.R.id.text1,
//                items
//        );
//        ListView listView = (ListView)findViewById(R.id.listView);
//        listView.setAdapter(adapter);
    }
}
