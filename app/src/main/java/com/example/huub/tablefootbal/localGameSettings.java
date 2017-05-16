package com.example.huub.tablefootbal;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class localGameSettings extends AppCompatActivity {

    private ListView mListViewBlue;
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

    private Socket mSocket;
    private final String username = Constants.USERNAME;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_local_game_settings);
        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket();
        mSocket.on("addPlayerToTeamRed", chooseSideRed);
        mSocket.on("addPlayerToTeamBlue", chooseSideBlue);
        mSocket.on("addPlayerToTeamMidden", chooseSideMidden);
        mSocket.connect();

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
                    updateUI();
                    mPlayersRed.add(sendedUsername);
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
                    updateUI();
                    mPlayersBlue.add(sendedUsername);
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
                    updateUI();
                    mPlayersMidden.add(sendedUsername);
                }
            });
        }
    };


    private void updateUI() {

        mBtnPlay.setEnabled(mainMenu.getIsConnected());

        // If the list adapter is null, a new one will be instantiated and set on our list view.
        if (mAdapterBlue == null) {
            mAdapterBlue = new ArrayAdapter<>(this,android.R.layout.simple_list_item_1, mPlayersBlue);
            mListViewBlue.setAdapter(mAdapterBlue);
        }else {
            // When the adapter is not null, it has to know what to do when our dataset changes, when a change happens we need to call this method on the adapter so that it will update internally.
            mAdapterBlue.notifyDataSetChanged();
        }
        if (mAdapterRed == null) {
            mAdapterRed = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, mPlayersRed);
            mListViewRed.setAdapter(mAdapterRed);
        }else {
            // When the adapter is not null, it has to know what to do when our dataset changes, when a change happens we need to call this method on the adapter so that it will update internally.
            mAdapterRed.notifyDataSetChanged();
        }
        if (mAdapterMidden == null) {
            mAdapterMidden = new ArrayAdapter<>(this,android.R.layout.simple_list_item_1, mPlayersMidden);
            mListViewMidden.setAdapter(mAdapterMidden);
        } else {
            // When the adapter is not null, it has to know what to do when our dataset changes, when a change happens we need to call this method on the adapter so that it will update internally.
            mAdapterMidden.notifyDataSetChanged();
        }
    }

    public void joinTeamRed (View v) {
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


    public void joinTeamBlue (View v) {
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

    public void joinTeamMidden (View v) {
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
        for (String player:mPlayersBlue) {
            mSocket.emit("addPlayer", "teamBlue", player);
        };
        for (String player:mPlayersRed) {
            mSocket.emit("addPlayer", "teamRed", player);
        };
        Intent i = new Intent(getApplicationContext(), TableFootbalController.class);
        System.out.println("TEAMS red:" + mPlayersRed + " blue: " + mPlayersBlue);
        Constants.TEAMBLUE = mPlayersBlue;
        Constants.TEAMRED = mPlayersRed;
        mSocket.emit("startGame");
        startActivity(i);
        finish();
    }
}
