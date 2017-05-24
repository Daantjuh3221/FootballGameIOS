package com.example.huub.tablefootbal;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

//tja

public class mainMenu extends AppCompatActivity implements  SocketConnection.onSocketGotLoginEvent{

    private String prefsFile = Constants.PREFERENCEFILENAME;
    private Socket mSocket;
    private TextView mJoinCode;
    private TextView mJoinStatus;
    private ImageView mRefreshButton;
    private Button mPlayLocal;


    @Override
    protected void onCreate(Bundle savedInstanceState){

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);;

        if (Constants.isConnected){
            if (savedInstanceState == null) {
                getSupportFragmentManager()
                        .beginTransaction()
                        .add(R.id.root_layout, connectToApple.newInstance(), "connectToApple")
                        .commit();
            }
        }



    }

    @Override
    public void isPlayerOne(boolean playerOne) {

    }

    @Override
    public void loginSucceeded(boolean loginSucceeded) {

    }

    @Override
    public void usernameExists(boolean usernameExists) {

    }

    @Override
    public void connectedToAppleTV(boolean connectedToAppleTV) {
        if (connectedToAppleTV){
            //is connected to apple tv
            System.out.println("Connected to apple tv (main menu)");
            Constants.isConnected = true;
            SharedPreferences sharedPrefs = getSharedPreferences(prefsFile, MODE_PRIVATE);
            SharedPreferences.Editor ed = sharedPrefs.edit();
            ed.putString("joinCode", Constants.JOINCODE);
            ed.commit();
        } else{
            System.out.println("Not connected to apple tv (main menu)");
            Constants.JOINCODE = "";
            Toast.makeText(this, "Could not connect", Toast.LENGTH_LONG).show();
        }
    }
}
