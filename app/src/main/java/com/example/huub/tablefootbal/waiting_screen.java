package com.example.huub.tablefootbal;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.WindowManager;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class waiting_screen extends AppCompatActivity {


    private Socket mSocket;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_waiting_screen);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.on("startLocal", onStartLocal);
        mSocket.connect();
    }

    private Emitter.Listener onStartLocal = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            Intent i = new Intent(getApplicationContext(), localGameSettings.class);
            startActivity(i);
        }
    };

}
