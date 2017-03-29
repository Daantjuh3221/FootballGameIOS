package com.example.huub.tablefootbal;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class codeScreen extends AppCompatActivity {

    TextView txtCode;
    private Socket mSocket;
    public String code;
    private boolean mExists = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_code_screen);

        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.on("appleTvExists", onAppleTvExists);
        mSocket.connect();

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        txtCode = (TextView) findViewById(R.id.codeText);
    }

    private Emitter.Listener onAppleTvExists = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            mExists = (boolean)args[0];
            if (!mExists) {
                Intent i = new Intent(getApplicationContext(), mainMenu.class);
                startActivity(i);
            } else{
                Constants.USERNAME = "";
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(codeScreen.this, "Cannot find Apple TV!", Toast.LENGTH_SHORT).show();

                    }
                });
            }
        }
    };
    public void submitCode(View v) {
        code = txtCode.getText().toString();
        mSocket.emit("userJoinAppleTV", code);
    }
}
