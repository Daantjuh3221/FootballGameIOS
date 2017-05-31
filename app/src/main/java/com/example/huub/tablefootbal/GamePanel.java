package com.example.huub.tablefootbal;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.PointF;
import android.graphics.Rect;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Vibrator;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

import android.support.v4.view.VelocityTrackerCompat;
import android.view.VelocityTracker;

import static android.content.Context.VIBRATOR_SERVICE;
import static com.example.huub.tablefootbal.MainThread.canvas;


/**
 * Created by Huub on 15-2-2017.
 */
public class GamePanel extends SurfaceView implements SurfaceHolder.Callback, SensorEventListener {
    StringBuilder sb = new StringBuilder();
/*    private static final String SERVER_ADDRESS  = "http://192.168.10.49:3000";*/
    private Socket mSocket;

    private MainThread thread;
    private Player player;
    private PointF playerPoint;
    private PointF currentPos = new PointF(0,0);
    private PointF previousPos = new PointF(0,0);
    private int mDeviceWidth;
    private int mDeviceHeight;
    private float counter = 0;
    private int countLimit = 100;

    //Database Var
    public PointF playerData;
    public int playerID = 12345;
    public int frameID = 0;
    public String stringFrameID;

    private Stick stick;
    private Bitmap[] sticks = new Bitmap[3];

    private SensorManager sensorManager;
    private Sensor mySensor;

    private float yRotation;
    private Point screenSize;

    private TableFootbalController tableFootbalController;

    private VelocityTracker mVelocityTracker = null;
    private float maxXVelocity;
    private float startVelocity;
    private float swipeVelocity;

    private Vibrator myVib;



    public GamePanel(Context context, SensorManager sensor, int deviceWidth, int deviceHeight, TableFootbalController tableFootbalController){
        super(context);
        mDeviceHeight = deviceHeight;
        mDeviceWidth = deviceWidth;
        getHolder().addCallback(this);
        thread = new MainThread(getHolder(),this);

        this.tableFootbalController = tableFootbalController;

        SocketConnection app = (SocketConnection) tableFootbalController.getApplication();
        mSocket = app.getSocket(context);
        mSocket.connect();

        getSticks();

        stick = new Stick(new Rect(200,200,400,400), Color.BLACK, sticks, deviceWidth, deviceHeight);
        sensorManager = sensor;
        mySensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
        sensorManager.registerListener(this, mySensor, sensorManager.SENSOR_DELAY_GAME);
        setFocusable(true);

        //Init player
        player = new Player(new Rect(200,200,400,400), Color.TRANSPARENT, new PointF(800,1600/2));
        playerPoint = new PointF(600,150);


    }

    private void getSticks() {
        sticks[0] = BitmapFactory.decodeResource(getResources(), R.drawable.newstick01);
        sticks[1] = BitmapFactory.decodeResource(getResources(), R.drawable.newstick02);
        sticks[2] = BitmapFactory.decodeResource(getResources(), R.drawable.newstick03);
    }



    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy){

    }

    @Override
    public void onSensorChanged(SensorEvent event){
        //System.out.println("x: "+event.values[0]*10);
        yRotation = event.values[0]*10;
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height){
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder ){
        thread = new MainThread(getHolder(), this);
        thread.setRunning(true);
        thread.start();
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder){
        boolean retry = true;
        while (true){
            try{
                thread.setRunning(false);
                thread.join();
            }catch (Exception e)
            {
                e.printStackTrace();
            }
            retry = false;
        }
    }


    @Override
    public boolean onTouchEvent(MotionEvent event) {
        int action = event.getActionMasked();
        // get pointer index from the event object
        int pointerIndex = event.getActionIndex();

        // get pointer ID
        int pointerId = event.getPointerId(pointerIndex);

        myVib = (Vibrator)this.getContext().getSystemService(VIBRATOR_SERVICE);

        switch(action) {
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_POINTER_DOWN:
                if(mVelocityTracker == null) {

                    mVelocityTracker = VelocityTracker.obtain();

                    mVelocityTracker.computeCurrentVelocity(1000);
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
                        playerPoint.set((int)event.getX(i)-150,(int)event.getY(i));
                    }
                    if(i == 1){
                        mVelocityTracker.addMovement(event);
                        maxXVelocity = 0;

                        mVelocityTracker.computeCurrentVelocity(1000);

                        maxXVelocity = mVelocityTracker.getYVelocity(i);
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_POINTER_UP:
                if(pointerIndex == 1){
                    swipeVelocity = maxXVelocity - startVelocity;
                    System.out.println("Swipe: " + swipeVelocity);
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


    public PointF getPos(){
        PointF d = new PointF(0,0);

        playerData = player.getPosition();
        d.x = (float) (((playerData.x - 600) / 3.8) * 2.5);
        d.y = playerData.y - 800;
        //d.y *= 2;
        /*if (d.x < 0) {
            d.x = 0;
        }
        */

        if (counter > countLimit) {
            player.setPosition(new PointF(d.x,0));
            counter = 0;
            //return d;
        }

        if (d.x < -250) {
            d.x = -250;
        }

        if (d.y > 45) {
            d.y = 45;
        }
        if (d.y < -45) {
            d.y = -45;
        }

        if (counter > countLimit) {
            d.y = 0;
        }
        previousPos = d;
        mSocket.emit("sendPositionYToAppleTV", d.x);
        System.out.println("Test: " + d.x);
        return d;
    }

    public void setPos(PointF new_pos){
        this.previousPos = new_pos;
    }

    public boolean inRange() {
        //previousPos = getPos();
        if (getPos().y < previousPos.y + 3 && getPos().y > previousPos.y - 3) {
            return true;
        } else {
            return false;
        }

    }

    public void update(){
        //previousPos = getPos();
//        if(inRange()){
//            counter++;
//        } else {
//            counter = 0;
//        }


        System.out.println(getPos());
        System.out.println(inRange());
        player.update(playerPoint, yRotation);
        stick.update(playerPoint.x - 100, player.getVelocity());

        frameID+=1;
        //update table
        //tableFootbalController.InsertData();
    }

    @Override
    public void draw(Canvas canvas){
        super.draw(canvas);
        if (Constants.TEAMRED.contains(Constants.USERNAME)) {
            canvas.drawColor(Color.argb(255, 204, 0 , 0));
        } else {
            canvas.drawColor(Color.argb(255, 0, 102, 255));
        }
        player.draw(canvas);
        stick.draw(canvas);

    }

}
