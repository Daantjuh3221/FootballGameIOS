package com.example.huub.tablefootbal;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;


/**
 * Created by Huub on 14-2-2017.
 */
public class Player extends Activity implements GameObject {

    private Rect player;
    private int color;
    private PointF position, velocity;
    private float cubeSize, acceptRadius, basicDelay, gyroscopeSensitivity, touchSensitivity;


    private float screenCapX, screenCapY, screenCenterY;

    public Player(Rect player, int color, PointF startPosition ){
        //initialize the contructor
        this.player = player;
        this.color = color;
        position = startPosition;
        velocity = new PointF(0,0);

        //initialize stick image
        //stick = BitmapFactory.decodeResource(getResources(), R.drawable.stick);

        //Sensitivity for the controller
        acceptRadius = 0.09f;
        cubeSize = 200;
        basicDelay = 10f;
        gyroscopeSensitivity = 8f;
        touchSensitivity = 6f;

        //Screencaps Hardcode
        screenCapX = 1080;
        screenCapY = 1920;
        screenCenterY = screenCapY/2;
    }

    public float getVelocity() {
        return velocity.y;
    }

    @Override
    public void update() {

    }

    public void update(PointF point, float rotation){
        //System.out.println(rotation);
        //maak de velocity
        //Velocity word alleen aangepast bij een grote hoeveelheid.
        if(!(rotation < acceptRadius && rotation > -acceptRadius)){
            //Y position Using the
            //Gyroscope
            velocity.y  = (rotation)*gyroscopeSensitivity;
            position.y += (velocity.y/basicDelay);
        }else
        {
            //desing Idea
            //velocity.y += screenCenterY - position.y/10;
        }

        //set the position for the
        //X value
        velocity.x = (point.x - position.x)*touchSensitivity;
        position.x += (velocity.x/basicDelay);

        //clamp the cube
        //HardCode Heeeeeel vies!
        if(position.x < cubeSize/2){position.x = cubeSize/2;}
        if(position.x > screenCapX - cubeSize/2){ position.x = screenCapX-cubeSize/2;}
        if(position.y < cubeSize/2){position.y = cubeSize/2;}
        if(position.y > screenCapY - cubeSize/2){ position.y = screenCapY-cubeSize/2;}

        drawCube();
        drawStick();
    }

    public PointF getPosition() {
        return position;
    }

    private void drawStick(){

        //draw the stick here
    }

    private void drawCube(){

        //Left, Top, Right, Down
        //Draw rect
        float left = position.x - cubeSize/2;
        float right = position.x + cubeSize/2;

        float top = position.y - cubeSize/2;
        float down = position.y + cubeSize/2;

        //Update rect
        player.set((int)left,(int)top,(int)right,(int)down);
    }

    public float getPlayerPositionX() {
        return position.x;
    }

    @Override
    public void draw(Canvas canvas) {
        Paint paint = new Paint();
        paint.setColor(color);
        canvas.drawRect(player, paint);
    }
}
