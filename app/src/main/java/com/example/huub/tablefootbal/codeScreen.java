package com.example.huub.tablefootbal;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class codeScreen extends AppCompatActivity implements SocketConnection.onSocketGotLoginEvent {

    TextView txtCode;
    private Socket mSocket;
    private String code;
    private boolean mExists = false;
    private String prefsFile = Constants.PREFERENCEFILENAME;
    private SharedPreferences sharedPrefs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_code_screen);

        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket(this);

        sharedPrefs =  getApplicationContext().getSharedPreferences(prefsFile, MODE_PRIVATE);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        txtCode = (TextView) findViewById(R.id.codeText);
    }




    public void submitCode(View v) {
        code = txtCode.getText().toString();
        Constants.JOINCODE = code;
        mSocket.emit("userJoinAppleTV", code);
    }

    @Override
    public void isPlayerOne(boolean playerOne) {

    }

    @Override
    public void onDisconnectAppleTV() {

    }

    @Override
    public void loginSucceeded(boolean loginSucceeded) {

    }

    @Override
    public void startLocal() {

    }

    @Override
    public void usernameExists(boolean usernameExists) {

    }

    @Override
    public void connectedToAppleTV(boolean connectedToAppleTV, boolean goToChooseSide) {
        SharedPreferences sharedPref = getApplicationContext().getSharedPreferences(prefsFile, MODE_PRIVATE);
        SharedPreferences.Editor edit = sharedPref.edit();
        System.out.println("connectedToAppleTV?: " + connectedToAppleTV);
        if (connectedToAppleTV){
            edit.putString("joinCode", txtCode.getText().toString());
            edit.commit();
            if (Constants.isPlayerOne){
                Intent i = new Intent(this, mainMenu.class);
                startActivity(i);
                finish();
            } else{
                if (goToChooseSide){
                    Intent i = new Intent(this, localGameSettings.class);
                    startActivity(i);
                    finish();
                } else{
                    Intent i = new Intent(this, waiting_screen.class);
                    startActivity(i);
                    finish();
                }

            }
        } else{
            Toast.makeText(getApplicationContext(),"Could not find apple tv",Toast.LENGTH_SHORT).show();
        }

    }
}
