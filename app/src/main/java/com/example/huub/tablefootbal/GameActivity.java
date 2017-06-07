package com.example.huub.tablefootbal;

import android.graphics.Color;
import android.os.Vibrator;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;

import io.socket.client.Socket;

public class GameActivity extends AppCompatActivity {

    private ImageView stick;
    private int frameHeight;
    private double frameMiddle;
    private int currentFingerPositionY;
    private int previousFingerPositionY;
    private int stickSize;
    private int stickPositionY;
    private FrameLayout frame;
    private Socket mSocket;
    private VelocityTracker mVelocityTracker = null;
    private float maxXVelocity;
    private float startVelocity;
    private float swipeVelocity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        frame = (FrameLayout)findViewById(R.id.gameFrame);
        stick = (ImageView) findViewById(R.id.stick);
        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket(this);
        mSocket.connect();
        checkTeam();


    }

    private void sendToAppleTV() {
        if(currentFingerPositionY != previousFingerPositionY) {
            if (currentFingerPositionY >= (frameHeight - 80)){
                currentFingerPositionY = frameHeight;
            }

            if (currentFingerPositionY <= 70){
                currentFingerPositionY = 0;
            }

            //System.out.println("CurrentFingerPosition is : " + currentFingerPositionY);

            Double doubleValue = (((currentFingerPositionY - frameMiddle) / frameMiddle) * 290);
            int intValueForAppleTV = doubleValue.intValue() * -1;
            mSocket.emit("sendPositionYToAppleTV", intValueForAppleTV);
            previousFingerPositionY = currentFingerPositionY;
        }

    }

    private void stickPosition(){
        System.out.println("stickposition: " + stickPositionY);
        if (stickPositionY <= -500){
            stickPositionY = -500;
        }

        if (stickPositionY >= 15){
            stickPositionY = 15;
        }

        stick.setY(stickPositionY);

    }

    @Override
    public boolean onTouchEvent(MotionEvent event){
        int action = event.getActionMasked();
        int pointerIndex = event.getActionIndex();

        Vibrator myVib = (Vibrator)this.getSystemService(VIBRATOR_SERVICE);

        stickSize = stick.getHeight();

        frameHeight = frame.getHeight();
        frameMiddle = frameHeight/2.0;

        currentFingerPositionY = (int)event.getY();
        stickPositionY = (int)event.getY() - (800);

        switch (action){
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_POINTER_DOWN:
                if(mVelocityTracker == null) {

                    mVelocityTracker = VelocityTracker.obtain();

                    mVelocityTracker.computeCurrentVelocity(1);
                    startVelocity = mVelocityTracker.getXVelocity(pointerIndex);
                    System.out.println("StartSnelheid " + startVelocity);

                }
                else {
                    // Reset the velocity tracker back to its initial state.
                    mVelocityTracker.clear();
                }
                // Add a user's movement to the tracker.
                mVelocityTracker.addMovement(event);
                break;
            case MotionEvent.ACTION_MOVE:
                for (int size = event.getPointerCount(), i = 0; i < size; i++) {
                    if(i == 0){
                        sendToAppleTV();
                        stickPosition();
                    }
                    if(i == 1){
                        mVelocityTracker.addMovement(event);
                        maxXVelocity = 0;

                        mVelocityTracker.computeCurrentVelocity(1000);

                        maxXVelocity = mVelocityTracker.getXVelocity(i);
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_POINTER_UP:
                if(pointerIndex == 1){
                    swipeVelocity = maxXVelocity - startVelocity;
                    System.out.println("Swipe: " + swipeVelocity);
                    System.out.println("Swipe velocity: " + swipeVelocity);
                    mSocket.emit("sendPositionXToAppleTV", swipeVelocity);
                    myVib.vibrate(Constants.VIBRATIONDEFAULT);
                }
                break;
            case MotionEvent.ACTION_CANCEL:
                // Return a VelocityTracker object back to be re-used by others.
                mVelocityTracker.recycle();
                mVelocityTracker = null;
                break;
        }
        return true;
    }

    private void checkTeam(){
        if (true) {//hier moet nog code neergezet worden
            frame.setBackgroundColor(Color.RED);
        } else {
            frame.setBackgroundColor(Color.BLUE);
        }
    }
}
