package com.example.huub.tablefootbal;

import android.app.Activity;
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

import io.socket.client.Socket;

/**
 * Created by Lars on 8-3-2017.
 */

public class Splash extends AppCompatActivity {

    private String prefsFile = Constants.PREFERENCEFILENAME;
    private Socket mSocket;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen);

        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.connect();

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);


        Thread myThread = new Thread() {
            @Override
            public void run() {
                Intent i = new Intent(getApplicationContext(), joinScreen.class);
                try {
                    SharedPreferences sharedPrefs = getSharedPreferences(prefsFile, MODE_PRIVATE);
                    SharedPreferences.Editor ed;
                    if(!sharedPrefs.contains("initialized")) {

                        ed = sharedPrefs.edit();

                        //Indicate that the default shared prefs have been set
                        ed.putBoolean("initialized", true);
                        ed.commit();
                    }
//                    } else if(sharedPrefs.contains("username")){
//                        String username = sharedPrefs.getString("username", "");
//                        mSocket.emit("registeredUserConnect", username, Constants.DEVICE);
//                    } else if(sharedPrefs.contains("joinCode")){
//                        String joinCode = sharedPrefs.getString("joinCode", "");
//                        mSocket.emit("userJoinAppleTV", joinCode);
//                    }
                    sleep(2000);
                    startActivity(i);
                    finish();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };
        myThread.start();
    }

}