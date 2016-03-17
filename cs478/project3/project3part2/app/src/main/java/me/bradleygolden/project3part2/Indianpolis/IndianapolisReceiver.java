package me.bradleygolden.project3part2.Indianpolis;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/**
 * Created by bradleygolden on 3/15/16.
 */
public class IndianapolisReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // Open Indianapolis Activity
        Intent aIntent = new Intent(context, IndyAttractionViewerActivity.class);
        context.startActivity(aIntent);
    }
}
