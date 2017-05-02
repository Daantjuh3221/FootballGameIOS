package com.example.huub.tablefootbal;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

/**
 * Created by Lars on 8-3-2017.
 */

public class joinScreen extends AppCompatActivity {

    TextView txtUserName;
    public String userName;
    private Socket mSocket;
    private boolean mExists = false;
    private final SharedPreferences settings = getSharedPreferences(Constants.PREFERENCEFILENAME, Context.MODE_PRIVATE);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join_screen);
        txtUserName = (TextView) findViewById(R.id.userName);
        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.on("usernameExists", onUsernameExists);
        mSocket.connect();

        if (settings.contains("username")){
            Constants.USERNAME = settings.getString("username", "NO USERNAME");
            mSocket.emit("connectUser", Constants.USERNAME, Constants.DEVICE, false);
            Intent i = new Intent(getApplicationContext(), codeScreen.class);
            startActivity(i);
            finish();
        }
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    private Emitter.Listener onUsernameExists = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
                mExists = (boolean)args[0];
                if (!mExists) {
                    SharedPreferences settings = getSharedPreferences(Constants.PREFERENCEFILENAME, 0);
                    SharedPreferences.Editor editor = settings.edit();
                    editor.putString("username", Constants.USERNAME);
                    // Commit the edits!
                    editor.commit();
                    Intent i = new Intent(getApplicationContext(), codeScreen.class);
                    startActivity(i);
                    finish();
                } else{
                    Constants.USERNAME = "";
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(joinScreen.this, "Username already exists!", Toast.LENGTH_SHORT).show();

                        }
                    });
                }
            }
    };

    public void joinGame(View v) {
        userName = txtUserName.getText().toString();
        Constants.USERNAME = userName;
        mSocket.emit("connectUser", Constants.USERNAME, Constants.DEVICE, true);
    }
}