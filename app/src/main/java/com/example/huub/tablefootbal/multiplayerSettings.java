package com.example.huub.tablefootbal;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class multiplayerSettings extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_multiplayer_settings);
    }

    public void playMultiplayerGame(View v) {
        Intent i = new Intent(getApplicationContext(), TableFootbalController.class);
        startActivity(i);
        finish();
    }
}
