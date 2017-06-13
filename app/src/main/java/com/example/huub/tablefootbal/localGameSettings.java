package com.example.huub.tablefootbal;

import android.content.Intent;
import android.os.Vibrator;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class localGameSettings extends AppCompatActivity implements SocketConnection.onPlayGameEvent {

    private ListView  mListViewBlue;
    private ListView mListViewRed;
    private ListView mListViewMidden;

    private Button mBtnBlue;
    private Button mBtnRed;
    private Button mBtnMidden;
    private Button mBtnPlay;

    private static boolean isConnected;

    private ArrayAdapter mAdapterBlue;
    private ArrayAdapter mAdapterRed;
    private ArrayAdapter mAdapterMidden;

    private List<String> mPlayersBlue;
    private List<String> mPlayersRed;
    private List<String> mPlayersMidden;

    private boolean everybodyIsReady = false;
    private Socket mSocket;
    private final String username = Constants.USERNAME;

    private Vibrator myVib;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_local_game_settings);

        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket(this);
        mSocket.on("addPlayerToTeamRed", chooseSideRed);
        mSocket.on("addPlayerToTeamBlue", chooseSideBlue);
        mSocket.on("addPlayerToTeamMidden", chooseSideMidden);
        mSocket.connect();

        myVib = (Vibrator) this.getSystemService(VIBRATOR_SERVICE);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        mPlayersBlue = new ArrayList<String>();
        mPlayersRed = new ArrayList<String>();
        mPlayersMidden = new ArrayList<String>();

        mPlayersMidden.add(Constants.USERNAME);

        mListViewBlue = (ListView) findViewById(R.id.listViewBlue);
        mListViewRed = (ListView) findViewById(R.id.listViewRed);
        mListViewMidden = (ListView) findViewById(R.id.listViewMidden);

        mBtnMidden = (Button) findViewById(R.id.joinTeamMidden);
        mBtnBlue = (Button) findViewById(R.id.joinTeamBlue);
        mBtnRed = (Button) findViewById(R.id.joinTeamRed);
        mBtnPlay = (Button) findViewById(R.id.playLocalGame);

        mListViewMidden.setEnabled(false);
        mListViewMidden.setClickable(false);
        mListViewBlue.setEnabled(false);
        mListViewBlue.setClickable(false);
        mListViewRed.setEnabled(false);
        mListViewRed.setClickable(false);

        //if the player is not Player 1, the button text is set to "Ready"
        if (!Constants.isPlayerOne){
            mBtnPlay.setText("Ready");
        }

        mBtnMidden.setEnabled(false);


        updateUI();

    }

    private Emitter.Listener chooseSideRed = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    String sendedUsername = args[0].toString();
                    if (mPlayersBlue.contains(sendedUsername)){
                        mPlayersBlue.remove(sendedUsername);
                    }
                    if (mPlayersMidden.contains(sendedUsername)){
                        mPlayersMidden.remove(sendedUsername);
                    }
                    mPlayersRed.add(sendedUsername);
                    updateUI();

                }
            });
        }
    };

    private Emitter.Listener chooseSideBlue = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    String sendedUsername = args[0].toString();
                    if (mPlayersRed.contains(sendedUsername)){
                        mPlayersRed.remove(sendedUsername);
                    }
                    if (mPlayersMidden.contains(sendedUsername)){
                        mPlayersMidden.remove(sendedUsername);
                    }
                    mPlayersBlue.add(sendedUsername);
                    updateUI();

                }
            });
        }
    };

    private Emitter.Listener chooseSideMidden = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    String sendedUsername = args[0].toString();
                    if (mPlayersRed.contains(sendedUsername)){
                        mPlayersRed.remove(sendedUsername);
                    }
                    if (mPlayersBlue.contains(sendedUsername)){
                        mPlayersBlue.remove(sendedUsername);
                    }
                    mPlayersMidden.add(sendedUsername);
                    updateUI();

                }
            });
        }
    };


    private void updateUI() {


        // If the list adapter is null, a new one will be instantiated and set on our list view.
        if (mAdapterBlue == null) {
            mAdapterBlue = new ArrayAdapter<>(this,android.R.layout.simple_list_item_1, mPlayersBlue);
            mListViewBlue.setAdapter(mAdapterBlue);
        }
        if (mAdapterRed == null) {
            mAdapterRed = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, mPlayersRed);
            mListViewRed.setAdapter(mAdapterRed);
        }
        if (mAdapterMidden == null) {
            mAdapterMidden = new ArrayAdapter<>(this,android.R.layout.simple_list_item_1, mPlayersMidden);
            mListViewMidden.setAdapter(mAdapterMidden);
        }
        mAdapterMidden.notifyDataSetChanged();
        mAdapterRed.notifyDataSetChanged();
        mAdapterBlue.notifyDataSetChanged();


        if (Constants.isPlayerOne){
            if (everybodyIsReady && mListViewMidden.getCount() == 0 && mListViewBlue.getCount() > 0 && mListViewRed.getCount() > 0){
                mBtnPlay.setEnabled(true);
            } else{
                mBtnPlay.setEnabled(false);
            }
        }

    }

    //button for chosing red side
    //onclick vibration
    //button gets disabled after being clicked, other team buttons get enabled
    //username gets removed from the other views and added to the view on top of this button
    public void joinTeamRed (View v) {
        myVib.vibrate(Constants.VIBRATIONDEFAULT);
        mBtnRed.setEnabled(false);
        mBtnMidden.setEnabled(true);
        mBtnBlue.setEnabled(true);

        if (mPlayersBlue.contains(username)){
            mPlayersBlue.remove(username);
        }
        if (mPlayersMidden.contains(username)){
            mPlayersMidden.remove(username);
        }

        mPlayersRed.add(username);
        updateUI();
        mSocket.emit("chooseSideRed");
    }



    //button for chosing blue side
    //onclick vibration
    //button gets disabled after being clicked, other team buttons get enabled
    //username gets removed from the other views and added to the view on top of this button
    public void joinTeamBlue (View v) {
        myVib.vibrate(Constants.VIBRATIONDEFAULT);
        mBtnRed.setEnabled(true);
        mBtnMidden.setEnabled(true);
        mBtnBlue.setEnabled(false);

        if (mPlayersRed.contains(username)){
            mPlayersRed.remove(username);
        }
        if (mPlayersMidden.contains(username)){
            mPlayersMidden.remove(username);
        }

        mPlayersBlue.add(username);
        updateUI();
        mSocket.emit("chooseSideBlue");
    }


    //button for chosing no team
    //onclick vibration
    //button gets disabled after being clicked, other team buttons get enabled
    //username gets removed from the other views and added to the view on top of this button
    public void joinTeamMidden (View v) {
        myVib.vibrate(Constants.VIBRATIONDEFAULT);
        mBtnRed.setEnabled(true);
        mBtnMidden.setEnabled(false);
        mBtnBlue.setEnabled(true);

        if (mPlayersBlue.contains(username)){
            mPlayersBlue.remove(username);
        }
        if (mPlayersRed.contains(username)){
            mPlayersRed.remove(username);
        }

        mPlayersMidden.add(username);
        updateUI();
        mSocket.emit("chooseSideMidden");
    }


    public void playLocalGame(View v) {

        if (Constants.isPlayerOne){
            for (String player:mPlayersBlue) {
                mSocket.emit("addPlayer", "teamBlue", player);
            };
            for (String player:mPlayersRed) {
                mSocket.emit("addPlayer", "teamRed", player);
            };
            Intent i = new Intent(getApplicationContext(), GameActivity.class);
            System.out.println("TEAMS red:" + mPlayersRed + " blue: " + mPlayersBlue);
            Constants.TEAMBLUE = mPlayersBlue;
            Constants.TEAMRED = mPlayersRed;
            mSocket.emit("startGame");

            startActivity(i);
            finish();
        } else{
            mBtnPlay.setEnabled(false);
            mBtnBlue.setEnabled(false);
            mBtnMidden.setEnabled(false);
            mBtnRed.setEnabled(false);

            mBtnMidden.setEnabled(false);
            mBtnRed.setEnabled(false);
            mBtnBlue.setEnabled(false);

            mBtnPlay.setText("Waiting for player one");
            mSocket.emit("playerReady");
        }


    }

    @Override
    public void enableStart() {
        everybodyIsReady = true;
        updateUI();
    }

    @Override
    public void chooseSide() {

    }

    @Override
    public void startGame() {
        Intent i = new Intent(getApplicationContext(), GameActivity.class);
        System.out.println("TEAMS red:" + mPlayersRed + " blue: " + mPlayersBlue);
        Constants.TEAMBLUE = mPlayersBlue;
        Constants.TEAMRED = mPlayersRed;
        startActivity(i);
        finish();
    }
}
