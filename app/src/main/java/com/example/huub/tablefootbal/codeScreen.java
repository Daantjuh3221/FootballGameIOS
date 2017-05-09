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

public class codeScreen extends AppCompatActivity {

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
        mSocket = app.getSocket();
        mSocket.on("appleTvExists", onAppleTvExists);
        mSocket.on("isPlayerOne", onIsPlayerOne);
        mSocket.connect();

        sharedPrefs =  getApplicationContext().getSharedPreferences(prefsFile, MODE_PRIVATE);

        if(sharedPrefs.contains("joinCode")){
            Toast.makeText(codeScreen.this, "There is a join code saved: " + sharedPrefs.getString("joinCode", ""), Toast.LENGTH_SHORT).show();
            Constants.JOINCODE = sharedPrefs.getString("joinCode", "");
            mSocket.emit("userJoinAppleTV", Constants.JOINCODE);
        } else{
            Toast.makeText(codeScreen.this, "There is no Join code saved", Toast.LENGTH_SHORT).show();
        }

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        txtCode = (TextView) findViewById(R.id.codeText);
    }

    private Emitter.Listener onIsPlayerOne = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            Constants.isPlayerOne = (boolean)args[0];
            System.out.println("IS PLAYER ONE: " + Constants.isPlayerOne);
        }
    };

    private Emitter.Listener onAppleTvExists = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            mExists = (boolean)args[0];
            if (!mExists) {
                SharedPreferences.Editor editor = sharedPrefs.edit();
                Constants.isConnected = true;
                editor.putString("joinCode", Constants.JOINCODE);
                editor.commit();
                if (Constants.isPlayerOne){
                    System.out.println("WEL PLAYER 1");
                    Intent i = new Intent(getApplicationContext(), mainMenu.class);
                    startActivity(i);
                    finish();
                } else{
                    System.out.println("NIET PLAYER 1");
                    Intent i = new Intent(getApplicationContext(), waiting_screen.class);
                    startActivity(i);
                    finish();
                }

            } else{
                Constants.USERNAME = "";
                Constants.isConnected = false;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(codeScreen.this, "Cannot find Apple TV!", Toast.LENGTH_SHORT).show();

                    }
                });
            }
        }
    };
    public void submitCode(View v) {
        code = txtCode.getText().toString();
        Constants.JOINCODE = code;
        mSocket.emit("userJoinAppleTV", code);
    }
}
