package me.bradleygolden.Services.AudioService;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Created by bradleygolden on 4/5/16.
 */
public class TransactionHelper extends SQLiteOpenHelper {

    final static String TABLE_NAME = "songs";
    final static String DATE_TIME = "date_time";
    final static String REQUEST_TYPE = "request_type";
    final static String CLIP_NUMBER = "clip_number";
    final static String CURRENT_STATE = "current_state";
    final static String _ID = "_id";
    final static String[] columns = { _ID, DATE_TIME, REQUEST_TYPE, CLIP_NUMBER, CURRENT_STATE};

    final private static String CREATE_TABLE =

            "CREATE TABLE " + TABLE_NAME + " (" + _ID
                    + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + DATE_TIME + " TEXT NOT NULL,"
                    + REQUEST_TYPE + " TEXT NOT NULL,"
                    + CLIP_NUMBER + " TEXT,"
                    + CURRENT_STATE + " TEXT NOT NULL)";

    final private static String DATABASE_NAME = "song_db";
    final private static Integer DATABASE_VERSION = 1;
    final private Context mContext;

    TransactionHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.mContext = context;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_TABLE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // N/A
    }

    void deleteDatabase() {
        mContext.deleteDatabase(DATABASE_NAME);
    }
}
