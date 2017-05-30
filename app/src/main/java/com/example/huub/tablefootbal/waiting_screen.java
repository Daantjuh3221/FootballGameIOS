package com.example.huub.tablefootbal;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class waiting_screen extends AppCompatActivity {

    private TextView mUsername;
    private TextView mJoinCode;
    private TextView mJoinStatus;
    private ImageView mRefreshButton;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_waiting_screen);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        mUsername = (TextView)findViewById(R.id.username);
        mJoinCode = (TextView)findViewById(R.id.lblJoinCode);
        mJoinStatus = (TextView)findViewById(R.id.lblServerStatus);
        mRefreshButton = (ImageView) findViewById(R.id.imgRefreshButton);

        mUsername.setText(Constants.USERNAME);
        if (Constants.isConnectedServer){
            mJoinStatus.setTextColor(Color.GREEN);
            mJoinStatus.setText(Constants.JOINEDTEXT);
        } else{
            mJoinStatus.setTextColor(Color.RED);
            mJoinStatus.setText(Constants.DISCONNECTEDTEXT);
        }


        System.out.println("value in main menu is: " + Constants.isConnectedAppleTV);
        if (Constants.isConnectedAppleTV){
            mJoinCode.setText(Constants.JOINCODE);
        } else{
            mJoinCode.setText(Constants.DISCONNECTEDTEXT);
            mJoinCode.setTextColor(Color.RED);
        }
    }

    public void selectSettings (View v) {
        Intent i = new Intent(getApplicationContext(), MainMenuSettings.class);
        startActivity(i);
    }

}
