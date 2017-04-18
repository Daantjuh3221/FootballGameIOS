package com.example.huub.tablefootbal;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

import io.socket.client.Socket;

//tja

public class mainMenu extends AppCompatActivity {

    private Socket mSocket;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);

        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.connect();


        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    public void playLocal (View v) {

        mSocket.emit("playLocal");
        Intent i = new Intent(getApplicationContext(), localGameSettings.class);
        startActivity(i);
    }

    public void playMultiplayer (View v) {
        Intent i = new Intent(getApplicationContext(), multiplayerSettings.class);
        startActivity(i);
    }
}
