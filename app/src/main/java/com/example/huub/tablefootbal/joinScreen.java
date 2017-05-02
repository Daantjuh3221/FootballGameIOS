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
    private String prefsFile = Constants.PREFERENCEFILENAME;
    private SharedPreferences sharedPrefs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join_screen);
        txtUserName = (TextView) findViewById(R.id.userName);
        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.on("usernameExists", onUsernameExists);
        mSocket.connect();

        sharedPrefs =  getApplicationContext().getSharedPreferences(prefsFile, MODE_PRIVATE);

        if(sharedPrefs.contains("username")){
            Toast.makeText(joinScreen.this, "There is a username saved: " + sharedPrefs.getString("username", ""), Toast.LENGTH_SHORT).show();
            Constants.USERNAME = sharedPrefs.getString("username", "");
            mSocket.emit("registeredUserConnect", Constants.USERNAME, Constants.DEVICE);
            Intent i = new Intent(getApplicationContext(), codeScreen.class);
            startActivity(i);
            finish();
        } else{
            Toast.makeText(joinScreen.this, "There is no username saved", Toast.LENGTH_SHORT).show();
        }

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    private Emitter.Listener onUsernameExists = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
                mExists = (boolean)args[0];
                if (!mExists) {
                    if (userName != ""){
                        SharedPreferences.Editor editor = sharedPrefs.edit();
                        editor.putString("username", userName);
                        editor.commit();
                    } else{
                        SharedPreferences.Editor editor = sharedPrefs.edit();
                        editor.putString("username", "developer");
                        editor.commit();
                    }
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
        if (userName.equals("")){
            mSocket.emit("developUserConnect", Constants.USERNAME, Constants.DEVICE);
        } else{
            mSocket.emit("newUserConnect", Constants.USERNAME, Constants.DEVICE);
        }
    }
}