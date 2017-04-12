package com.example.huub.tablefootbal;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

//tja

public class mainMenu extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    public void playLocal (View v) {
        Intent i = new Intent(getApplicationContext(), localGameSettings.class);
        startActivity(i);
    }

    public void playMultiplayer (View v) {
        Intent i = new Intent(getApplicationContext(), multiplayerSettings.class);
        startActivity(i);
    }
}
