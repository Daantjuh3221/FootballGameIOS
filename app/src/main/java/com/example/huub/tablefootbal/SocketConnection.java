package com.example.huub.tablefootbal;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.annotation.Nullable;
import android.widget.Toast;

import java.net.URISyntaxException;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

/**
 * Created by Lars on 29-3-2017.
 */

public class SocketConnection extends Application {


    private boolean loginSucceeded;
    private Context mContext;
    private onErrorSocketEvent mErrorListener;
    private onSocketGotLoginEvent mLoginListener;

    private Socket mSocket;
    {
        try {
            IO.Options opt = new IO.Options();
            opt.reconnection = true;
            opt.reconnectionAttempts = 5;
            mSocket = IO.socket(Constants.SERVER_URL);
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    @Nullable
    public Socket getSocket(Context context) {

        mContext = context;
        if (mContext != null){
            if(mContext instanceof onSocketGotLoginEvent) {
                mLoginListener = (onSocketGotLoginEvent) mContext;
            }
            if(mContext instanceof onErrorSocketEvent) {
                mErrorListener = (onErrorSocketEvent) mContext;
            }
        } else{
            System.out.println("HELP: context is null");
        }

        mSocket.on("isPlayerOne", onIsPlayerOne);
        mSocket.on("loginSucceeded", onLogin);
        mSocket.on("disconnect", onDisconnect);
        mSocket.on("connect_error", onSocketConnectError);
        mSocket.on("error", onSocketError);
        mSocket.on(Socket.EVENT_CONNECT, onConnect);
        mSocket.on("usernameExists", onUsernameExists);
        mSocket.on("appleTvExists", onAppleTvExists);
        return mSocket;
    }

    ///////////////////////////
    //Connect handeling
    //////////////////////////
    private Emitter.Listener onConnect = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            System.out.println("Connected");
            Constants.isConnected = true;
        }
    };

    ///////////////////////////
    //Error handeling
    //////////////////////////
    private Emitter.Listener onDisconnect = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
        ((Activity)(mContext)).runOnUiThread(new Runnable() {
            @Override
            public void run() {
            if (mErrorListener != null){
                mErrorListener.disconnected();
                mSocket.disconnect();
                mSocket.off();
                System.out.println("DISCONNECTED");
            } else{
                System.out.println("Mlistener is null");
            }
            }
        });

        }
    };


    private Emitter.Listener onSocketError = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
        ((Activity)(mContext)).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mErrorListener != null){
                    mErrorListener.socketError(args[0].toString());
                    mErrorListener.disconnected();
                    mSocket.disconnect();
                    mSocket.off();
                    System.out.println("SOCKET ERROR");
                } else{
                    System.out.println("Mlistener is null");
                }
            }
        });
        }
    };

    private Emitter.Listener onSocketConnectError = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            ((Activity)(mContext)).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mErrorListener != null){
                        mErrorListener.socketConnectError(args[0].toString());
                        mSocket.disconnect();
                        mSocket.off();
                        System.out.println("CONNECT ERROR");
                    } else{
                        System.out.println("Mlistener is null");
                    }
                }
            });
        }
    };

    //////////////////////////
    //Login listeners
    //////////////////////////
    private Emitter.Listener onIsPlayerOne = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            Constants.isPlayerOne = (boolean)args[0];
            if (mLoginListener != null){
                mLoginListener.isPlayerOne(Constants.isPlayerOne);
                System.out.println("IS PLAYER ONE: " + Constants.isPlayerOne);
            } else{
                System.out.println("Mlistener is null");
            }
        }
    };

    private Emitter.Listener onAppleTvExists = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            ((Activity)(mContext)).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    boolean exists = (boolean)args[0];
                    if (mLoginListener != null){
                        if (exists) {
                            System.out.println("Apple tv exist");
                            Constants.isConnected = exists;
                            mLoginListener.connectedToAppleTV(exists);
                        } else{
                            System.out.println("Apple tv does not exist");
                            mLoginListener.connectedToAppleTV(exists);
                        }
                    } else{
                        System.out.println("mlistener is null");
                    }
                }
            });

        }
    };

    private Emitter.Listener onUsernameExists = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            if (mLoginListener != null){
                mLoginListener.usernameExists((boolean)args[0]);
            } else{
                System.out.println("Mlistener is null");
            }
        }
    };

    private Emitter.Listener onLogin = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            ((Activity)(mContext)).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    loginSucceeded = (boolean)args[0];
                    if (mLoginListener != null){
                        mLoginListener.loginSucceeded(loginSucceeded);
                    } else{
                        System.out.println("Mlistener is null");
                    }
                }
            });

        }
    };

    public interface onErrorSocketEvent {
        void disconnected();
        void socketError(String error);
        void socketConnectError(String error);

    }

    public interface onSocketGotLoginEvent {
        void isPlayerOne(boolean playerOne);
        void loginSucceeded(boolean loginSucceeded);
        void usernameExists(boolean usernameExists);
        void connectedToAppleTV(boolean connectedToAppleTV);
    }
}
