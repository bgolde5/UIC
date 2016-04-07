package me.bradleygolden.PlayerClient;

import android.app.Activity;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.List;

public class HistoryActivity extends Activity {

    private static final String TAG = HistoryActivity.class.getName();
    SongPlayer songPlayer = null;
    ListView historyView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);

        historyView = (ListView)findViewById(R.id.historyListView);

        // Get the song player for retrieving transactions
        songPlayer = SongPlayer.getInstance();

        // Get all of the transactions thus far
        List<String> transactions = songPlayer.getTransactions();

        ArrayAdapter<String> adapter;

        if (transactions.size() <= 0){

            String[] strings = {"No transactions yet."};
            adapter = new ArrayAdapter<String>(this,
                    android.R.layout.simple_list_item_1, strings);
        } else {
            adapter = new ArrayAdapter<String>(this,
                    android.R.layout.simple_list_item_1, transactions);
        }

        historyView.setAdapter(adapter);
    }
}
