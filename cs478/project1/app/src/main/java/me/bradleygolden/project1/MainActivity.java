package me.bradleygolden.project1;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MainActivity extends AppCompatActivity {

    public static final int COMPOSE_MESSAGE_CODE = 1;

    public String getPhoneNumber(String msg) {

        // used regular expressions to simplify string parsing
        // match (###) ###-#### or (###)###-####
        String phoneRegEx = "([(]\\d{3}[)] \\d{3}[-]\\d{4})|([(]\\d{3}[)]\\d{3}[-]\\d{4})";
        Pattern phoneNumberPattern = Pattern.compile(phoneRegEx);
        Matcher phoneNumberMatcher = phoneNumberPattern.matcher(msg);

        if (phoneNumberMatcher.find( )) {
            return phoneNumberMatcher.group(0);
        }

        return null;
    }

    public void composeMessage(String phoneNumber) {

        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setType("vnd.android-dir/mms-sms"); // invoke sms and mms clients
        intent.putExtra("address", phoneNumber);

        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(intent, COMPOSE_MESSAGE_CODE);
        }
    }

    public void submitButtonOnClick(View v) {

        Button button = (Button)v;
        EditText editText = (EditText)findViewById(R.id.message);

        String msg = editText.getText().toString();

        String phoneNumber = this.getPhoneNumber(msg);

        if (phoneNumber != null) {
            this.composeMessage(phoneNumber);
        }
        else {
            return;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        EditText editText = (EditText)findViewById(R.id.message);

        if (requestCode == COMPOSE_MESSAGE_CODE) {
            editText.setText("Returning from Compose Message...");
        }

        super.onActivityResult(requestCode, resultCode, data);
    }
}