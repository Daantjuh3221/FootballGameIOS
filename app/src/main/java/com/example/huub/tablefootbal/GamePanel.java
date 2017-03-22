package com.example.huub.tablefootbal;

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
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.net.URISyntaxException;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

import static com.example.huub.tablefootbal.MainThread.canvas;

/**
 * Created by Huub on 15-2-2017.
 */
public class GamePanel extends SurfaceView implements SurfaceHolder.Callback, SensorEventListener {
    StringBuilder sb = new StringBuilder();
    private static final String SERVER_ADDRESS  = "http://192.168.10.49:3000";
    private Socket mSocket;

    private MainThread thread;
    private Player player;
    private PointF playerPoint;
    private PointF previousPos;
    private int mDeviceWidth;
    private int mDeviceHeight;
    private float counter = 0;
    private int countLimit = 20;

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


    public GamePanel(Context context, SensorManager sensor, int deviceWidth, int deviceHeight, TableFootbalController tableFootbalController){
        super(context);
        mDeviceHeight = deviceHeight;
        mDeviceWidth = deviceWidth;
        getHolder().addCallback(this);
        thread = new MainThread(getHolder(),this);
        try {
            mSocket = IO.socket(SERVER_ADDRESS);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        mSocket.on(Socket.EVENT_CONNECT, new Emitter.Listener() {

            @Override
            public void call(Object... args) {
                System.out.println("Socket connected");
            }

        });

        mSocket.connect();

        this.tableFootbalController = tableFootbalController;

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
        sticks[0] = BitmapFactory.decodeResource(getResources(), R.drawable.stick01);
        sticks[1] = BitmapFactory.decodeResource(getResources(), R.drawable.stick02);
        sticks[2] = BitmapFactory.decodeResource(getResources(), R.drawable.stick03);
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

    //jaja
    @Override
    public boolean onTouchEvent(MotionEvent event){
        switch (event.getAction()){
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_MOVE:
                playerPoint.set((int)event.getX(),(int)event.getY());
        }
        return true;
    }

    public  void DoNothing(){
        System.out.println("Niks");
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
        if (d.x < -250) {
            d.x = -250;
        }

        if (d.y > 90) {
            d.y = 90;
        }
        if (d.y < -90) {
            d.y = -90;
        }

        if (counter > countLimit) {
            d.y = 0;
        }
        previousPos = d;
        mSocket.emit("sendPositionY", d.x);
        mSocket.emit("sendPositionX", d.y);
        return d;
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
        canvas.drawColor(Color.WHITE);
        player.draw(canvas);
        stick.draw(canvas);

    }
}
