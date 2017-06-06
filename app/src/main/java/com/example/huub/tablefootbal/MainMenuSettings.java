package com.example.huub.tablefootbal;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.method.KeyListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;

import io.socket.client.Socket;
import io.socket.emitter.Emitter;

import static com.example.huub.tablefootbal.Constants.JOINCODE;
import static com.example.huub.tablefootbal.Constants.USERNAME;

public class MainMenuSettings extends AppCompatActivity implements SocketConnection.onSocketGotLoginEvent {

    private Socket mSocket;
    private TextView mUserName;
    private TextView mAppleTV;
    private String joinCode;

    private SharedPreferences sharedPrefs;

    private Button mChangeUser;
    private Button mChangeApple;

    private String prefsFile = Constants.PREFERENCEFILENAME;

    private KeyListener originalKeyListener;

    private final String username = USERNAME;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings_screen);
        SocketConnection app = (SocketConnection) getApplication();


        mChangeUser = (Button) findViewById(R.id.nameEditButton);
        mChangeApple = (Button) findViewById(R.id.editAppleButton);
        mUserName = (TextView)findViewById(R.id.userName);
        mAppleTV = (TextView) findViewById(R.id.appleID);

        sharedPrefs = getApplicationContext().getSharedPreferences(prefsFile, MODE_PRIVATE);

        mUserName.setText(USERNAME);
        mAppleTV.setText(JOINCODE);

        mSocket = app.getSocket(this);
        mSocket.connect();


        //Set fullscreen
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    //This method will be triggered when user clicks change username button
    public void changeUsername(View view) {
        // Activate new layout source to function as popup
        LayoutInflater inflater = getLayoutInflater();
        View alertLayout = inflater.inflate(R.layout.layout_custom_dialog, null);
        // Initiate its EditText
        final EditText etUsername = (EditText) alertLayout.findViewById(R.id.et_username);



        AlertDialog.Builder alert = new AlertDialog.Builder(this);
        // Set popup title
        alert.setTitle("Change username");
        // this is set the view from XML inside AlertDialog
        alert.setView(alertLayout);
        // disallow cancel of AlertDialog on click of back button and outside touch
        alert.setCancelable(false);
        alert.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                Toast.makeText(getBaseContext(), "Username remains " + Constants.USERNAME, Toast.LENGTH_SHORT).show();
            }
        });

        alert.setPositiveButton("Confirm", new DialogInterface.OnClickListener() {

            //This method will be triggered whenever the confirm option is chosen within the popup
            @Override
            public void onClick(DialogInterface dialog, int which) {
                SharedPreferences.Editor editor = sharedPrefs.edit();
                    String user = etUsername.getText().toString();
                // if the popup textfield is not empty, the input value will override constant USERNAME, else it will remain the previous value
                    if (!(user.isEmpty())) {
                    Constants.USERNAME = user;
                    mUserName.setText(user);
                    editor.putString("username", user);
                    editor.commit();
                    Toast.makeText(getBaseContext(), "Username: " + user, Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(getBaseContext(), "Username remains " + Constants.USERNAME, Toast.LENGTH_SHORT).show();
                }
            }
        });
        AlertDialog dialog = alert.create();
        dialog.show();
    }

    public void changeAppleID(View view) {
        LayoutInflater inflater = getLayoutInflater();
        View alertLayout = inflater.inflate(R.layout.layout_custom_dialog_apple , null);
        final EditText etApple = (EditText) alertLayout.findViewById(R.id.et_apple);


        AlertDialog.Builder alert = new AlertDialog.Builder(this);
        alert.setTitle("Change Apple ID");
        // this is set the view from XML inside AlertDialog
        alert.setView(alertLayout);
        // disallow cancel of AlertDialog on click of back button and outside touch
        alert.setCancelable(false);
        alert.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                Toast.makeText(getBaseContext(), "Apple ID remains " + Constants.JOINCODE, Toast.LENGTH_SHORT).show();
            }
        });

        alert.setPositiveButton("Confirm", new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                joinCode = etApple.getText().toString();
                if (!(joinCode.isEmpty())) {
                    mSocket.emit("userJoinAppleTV", joinCode);
                } else {
                    Toast.makeText(getBaseContext(), "Apple ID remains " + Constants.JOINCODE, Toast.LENGTH_SHORT).show();
                }
            }
        });
        AlertDialog dialog = alert.create();
        dialog.show();
    }


    public void returnButton(View v) {
        if (Constants.isConnectedAppleTV){
            if (Constants.isPlayerOne){
                Intent i = new Intent(getApplicationContext(), mainMenu.class);
                startActivity(i);
                finish();
            } else{
                Intent i = new Intent(getApplicationContext(), waiting_screen.class);
                startActivity(i);
                finish();
            }
        } else{
            Intent i = new Intent(getApplicationContext(), mainMenu.class);
            startActivity(i);
            finish();
        }


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
        if (connectedToAppleTV){
            SharedPreferences.Editor editor = sharedPrefs.edit();
            editor.putString("joinCode", joinCode);
            editor.commit();
            Constants.JOINCODE =joinCode;
            mAppleTV.setText(Constants.JOINCODE);
            Toast.makeText(getBaseContext(), "You are connected to: " + joinCode, Toast.LENGTH_SHORT).show();
        } else{
            mAppleTV.setText(Constants.JOINCODE);
            Toast.makeText(getBaseContext(), "Could not find apple tv: " + joinCode, Toast.LENGTH_SHORT).show();
        }
    }
}