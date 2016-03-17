package me.bradleygolden.project3;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    public static final String CHICAGO_INTENT = "some string";
    public static final String IND_INTENT = "some string";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button chicagoBtn = (Button)findViewById(R.id.chicagoBtn);
        Button indianapolisBtn = (Button)findViewById(R.id.indianapolisBtn);

        chicagoBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // show short toast message
                Toast.makeText(getApplicationContext(), "Chicago intent sent!", Toast.LENGTH_SHORT).show();

                // create and send intent to companion app
                Intent aIntent = new Intent(CHICAGO_INTENT);
                sendOrderedBroadcast(aIntent, null);
            }
        });

        indianapolisBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // show short toast message
                Toast.makeText(getApplicationContext(), "Indianapolis intent sent!", Toast.LENGTH_SHORT).show();

                // create and send intent to companion app
                Intent aIntent = new Intent(IND_INTENT);
                sendOrderedBroadcast(aIntent, null);
            }
        });



    }
}
