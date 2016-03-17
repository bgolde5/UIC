package me.bradleygolden.project3part2;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.Toast;

import me.bradleygolden.project3part2.Chicago.ChicagoAttractionViewerActivity;
import me.bradleygolden.project3part2.Chicago.ChicagoReceiver;
import me.bradleygolden.project3part2.Indianpolis.IndianapolisReceiver;

public class MainActivity extends AppCompatActivity {

    public static final String CHICAGO_INTENT = "me.bradleygolden.project3.chicago";
    public static final String IND_INTENT = "me.bradleygolden.project3.indianapolis";

    BroadcastReceiver chiReceiver = new ChicagoReceiver();
    IntentFilter chiFilter = new IntentFilter(CHICAGO_INTENT);

    BroadcastReceiver indReceiver = new IndianapolisReceiver();
    IntentFilter indFilter = new IntentFilter(IND_INTENT);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // wait for broadcast from Chicago
        registerReceiver(chiReceiver, chiFilter);

        // wait for broadcast from Indy
        registerReceiver(indReceiver, indFilter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        setTitle("Attractions Viewer");
        MenuInflater inflator = getMenuInflater();
        inflator.inflate(R.menu.project3_menu, menu);

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()){
            case R.id.chicago:

                //Start up Chicago activity
                startActivity(new Intent(getApplicationContext(), ChicagoAttractionViewerActivity.class));
                return true;
            case R.id.indy:

                //Start up Indy activity
                startActivity(new Intent(getApplicationContext(), ChicagoAttractionViewerActivity.class));
                return true;
            default:
                return false;
        }
    }

    // Unregister receivers for later use
    @Override
    protected void onDestroy() {
        unregisterReceiver(chiReceiver);
        unregisterReceiver(indReceiver);
        super.onDestroy();
    }
}
