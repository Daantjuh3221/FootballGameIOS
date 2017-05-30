package com.example.huub.tablefootbal;

import android.content.Intent;
import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

//tja

public class mainMenu extends AppCompatActivity {

    private Socket mSocket;
    private TextView mUsername;
    private TextView mJoinCode;
    private TextView mJoinStatus;
    private ImageView mRefreshButton;
    private Button mPlayLocal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);

        mPlayLocal = (Button) findViewById(R.id.startgameButton);
        mUsername = (TextView)findViewById(R.id.username);
        mJoinCode = (TextView)findViewById(R.id.lblJoinCode);
        mJoinStatus = (TextView)findViewById(R.id.lblJoinedStatus);
        mRefreshButton = (ImageView) findViewById(R.id.imgRefreshButton);

        mUsername.setText(Constants.USERNAME);
        if (Constants.isConnectedServer){
            mJoinStatus.setTextColor(Color.GREEN);
            mJoinStatus.setText(Constants.JOINEDTEXT);
        } else{
            mJoinStatus.setTextColor(Color.RED);
            mJoinStatus.setText(Constants.DISCONNECTEDTEXT);
        }

        if (Constants.isConnectedAppleTV){
            mJoinCode.setText(Constants.JOINCODE);
        } else{
            mJoinCode.setText(Constants.DISCONNECTEDTEXT);
            mJoinCode.setTextColor(Color.RED);
        }

        if (Constants.isConnectedAppleTV == true
                && Constants.isConnectedServer == true){
            mPlayLocal.setEnabled(true);
        } else{
            mPlayLocal.setEnabled(false);
        }



        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket(this);
        //mSocket.on("appleTvExists",reconnectWithAppleTV);
        mSocket.connect();

//        mRefreshButton.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                mSocket.emit("userJoinAppleTV", Constants.JOINCODE);
//                Animation rotation = AnimationUtils.loadAnimation(getBaseContext(), R.anim.rotation_clockwise);
//                mRefreshButton.startAnimation(rotation);
//            }
//        });

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }


    public void playLocal (View v) {

        mSocket.emit("playLocal");
        Intent i = new Intent(getApplicationContext(), localGameSettings.class);
        startActivity(i);
    }

    public void selectSettings (View v) {
        Intent i = new Intent(getApplicationContext(), MainMenuSettings.class);
        startActivity(i);
    }

//    private Emitter.Listener reconnectWithAppleTV = new Emitter.Listener() {
//        @Override
//        public void call(final Object... args) {
//            runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                    boolean exists = (boolean)args[0];
//                    System.out.println("OK: " + exists);
//                    if (!exists){
//                        System.out.println("OK: Zijn in exists");
//                        Constants.isConnected = true;
//                        Toast.makeText(getBaseContext(),"Reconnected with apple tv",
//                                Toast.LENGTH_LONG).show();
//                        System.out.println("OK: isconnected is" + Constants.isConnected);
//                    } else{
//                        Constants.isConnected = false;
//                        System.out.println("OK: isconnected is" + Constants.isConnected);
//                        System.out.println("OK: zijn niet in exists");
//                        Toast.makeText(getBaseContext(),"Could not connect with apple tv",
//                                Toast.LENGTH_LONG).show();
//                    }
//                }
//            });
//        }
//    };
}
