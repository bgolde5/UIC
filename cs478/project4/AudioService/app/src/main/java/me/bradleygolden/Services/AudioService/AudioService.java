package me.bradleygolden.Services.AudioService;

import android.app.Service;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.media.MediaPlayer;
import android.os.IBinder;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Calendar;
import java.util.TimeZone;

/**
 * Created by bradleygolden on 3/31/16.
 */
public class AudioService extends Service {

    protected static final String TAG = "AudioServiceServer";
    private static final String TIMEZONE = "America/Chicago";
    private MediaPlayer mediaPlayer = null;
    private String currentState = "after starting the app"; // Holds the current state of this service
    private String currClipName; // The name of the current clip being played

    private TransactionHelper mTransactionHelper;

    @Override
    public void onCreate() {
        super.onCreate();

        mTransactionHelper = new TransactionHelper(this);

        // start with an empty database
        clearAll();
    }

    // Insert a transaction record including the date/time (including seconds), the request type,
    // the clip number, and the current state of the service - Per specs
    private void insertTransaction(String requestType, int clipNumber) {

        TimeZone central = TimeZone.getTimeZone(TIMEZONE);
        SimpleDateFormat simpleFormat = new SimpleDateFormat("HH:mm:ss MM/dd/yyyy");
        simpleFormat.setTimeZone(central);

        String dateTime = simpleFormat.format(new Date());

        ContentValues values = new ContentValues();

        values.put(TransactionHelper.DATE_TIME, dateTime.toString());
        values.put(TransactionHelper.REQUEST_TYPE, requestType.toString());
        values.put(TransactionHelper.CLIP_NUMBER, clipNumber + "");
        values.put(TransactionHelper.CURRENT_STATE, currentState.toString());
        mTransactionHelper.getWritableDatabase().insert(TransactionHelper.TABLE_NAME, null, values);
    }

    // Delete all records
    private void clearAll() {
        mTransactionHelper.getWritableDatabase().delete(TransactionHelper.TABLE_NAME, null, null);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    private final IAudioService.Stub mBinder = new IAudioService.Stub() {

        public void playClip(String clip) {

            if (mediaPlayer == null) {
                // Create a media player with selected song
                // This gets called when a song gets called when a song gets started for the
                // first time or after a song was stopped
                try {
                    currClipName = clip;
                    mediaPlayer = MediaPlayer.create(getApplicationContext(), ClipMapping.getResID(currClipName));
                    mediaPlayer.start();

                    // Insert this transaction into the database
                    insertTransaction(
                            "Played",
                            ClipMapping.getClipNumber(ClipMapping.getResID(currClipName)));

                    currentState = "while playing " + ClipMapping.getClipNumber(ClipMapping.getResID(currClipName));

                    // record the transaction
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } else {
                // The song has been paused and will resume
                try {
                    resumeClip();
                } catch (Exception e) {
                    Log.e(TAG, e.getStackTrace().toString());
                }
            }
        }

        public void pauseClip() {
            mediaPlayer.pause();

            // Insert this transaction into the database
            insertTransaction(
                    "Paused",
                    ClipMapping.getClipNumber(ClipMapping.getResID(currClipName)));

            currentState = "after pausing " + ClipMapping.getClipNumber(ClipMapping.getResID(currClipName));
        }

        public void stopClip() {
            mediaPlayer.release();
            mediaPlayer = null;

            // Insert this transaction into the database
            insertTransaction(
                    "Stopped",
                    ClipMapping.getClipNumber(ClipMapping.getResID(currClipName)));

            currentState = "after stopping " + ClipMapping.getClipNumber(ClipMapping.getResID(currClipName));
        }

        public void resumeClip() {
            mediaPlayer.start();

            // Insert this transaction into the database
            insertTransaction(
                    "Resumed",
                    ClipMapping.getClipNumber(ClipMapping.getResID(currClipName)));

            currentState = "after resuming " + ClipMapping.getClipNumber(ClipMapping.getResID(currClipName));
        }

        public boolean isPlaying() {
            return mediaPlayer.isPlaying();
        }

        public List<String> getTransactions() {

            List<String> transactions = new ArrayList<String>();

            // Load all data from db
            Cursor cursor = readTransactions();

            // Go to first value in the db
            cursor.moveToFirst();

            // Retrieve all data from db in to string array
            while (!cursor.isAfterLast()) {
                String row = cursorRowToString(cursor);
                transactions.add(row);
                cursor.moveToNext();
            }

            // Make sure to close the cursor
            cursor.close();

            return transactions;
        }

        public void clearTransactions() {
            clearAll();
        }
    };

    private String cursorRowToString(Cursor cursor) {
        return String.format(cursor.getString(1) + " "
                + cursor.getString(2) + " "
                + cursor.getString(3) + " "
                + cursor.getString(4));
    }

    // Returns all transaction records in the database
    private Cursor readTransactions() {
        return mTransactionHelper.getWritableDatabase().query(TransactionHelper.TABLE_NAME,
                TransactionHelper.columns, null, new String[]{}, null, null,
                null);
    }

    @Override
    public void onDestroy() {

        // Close the media player
        if (mediaPlayer != null) {
            mediaPlayer.release();
        }
        mediaPlayer = null;

        // Delete the database
        mTransactionHelper.getWritableDatabase().close();
        mTransactionHelper.deleteDatabase();

        super.onDestroy();
    }
}
