package me.bradleygolden.project3part2.Chicago;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/**
 * Created by bradleygolden on 3/15/16.
 */
public class ChicagoReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // Open Chicago Activity
        Intent aIntent = new Intent(context, ChicagoAttractionViewerActivity.class);
        context.startActivity(aIntent);
    }
}
