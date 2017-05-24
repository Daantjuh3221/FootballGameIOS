package com.example.huub.tablefootbal;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import io.socket.client.Socket;

/**
 * Created by Lars on 8-3-2017.
 */

public class joinScreen extends AppCompatActivity implements SocketConnection.onSocketGotLoginEvent{

    private TextView txtUserName;
    private Button btnJoinGame;
    private String username;
    private Socket mSocket;
    private boolean mExists = false;
    private String prefsFile = Constants.PREFERENCEFILENAME;
    private SharedPreferences sharedPrefs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join_screen);
        txtUserName = (TextView) findViewById(R.id.userName);
        btnJoinGame = (Button) findViewById(R.id.joinGameButton);
        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket(this);
        sharedPrefs =  getApplicationContext().getSharedPreferences(prefsFile, MODE_PRIVATE);

        //Fired when the join button is clicked
        btnJoinGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                username = txtUserName.getText().toString();
                if (username.equals(""))
                {
                    Toast.makeText(joinScreen.this, "Fill in a name", Toast.LENGTH_LONG).show();
                }
                else{
                    mSocket.emit("newUserConnect", username, Constants.DEVICE);
                }
            }
        });

        //
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    @Override
    public void isPlayerOne(boolean playerOne){

    }

    @Override
    public void loginSucceeded(boolean loginSucceeded) {

    }

    @Override
    public void usernameExists(boolean usernameExists) {
        if (usernameExists){
            Toast.makeText(this, "Username already exists, choose another", Toast.LENGTH_LONG).show();
        } else{
            Constants.isLogedin = true;
            Constants.USERNAME = username;
            System.out.println("user is connected as: " + username);

            SharedPreferences.Editor ed = sharedPrefs.edit();
            ed.putString("username", username);
            ed.commit();

            Intent i = new Intent(this, mainMenu.class);
            startActivity(i);
            finish();
        }
    }

    @Override
    public void connectedToAppleTV(boolean connectedToAppleTV) {

    }
}