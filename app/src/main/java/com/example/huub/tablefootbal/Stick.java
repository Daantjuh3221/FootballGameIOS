package com.example.huub.tablefootbal;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PointF;
import android.graphics.Rect;
import android.util.DisplayMetrics;
import android.view.WindowManager;

/**
 * Created by Jelle on 7-3-2017.
 */

public class  Stick extends Activity implements GameObject {

    private Bitmap[] stick;
    private int color;
    private PointF position;
    private int stickCount;
    private int aanimationCounter;
    private int animationLimit;
    private int direction;
    private int stickSensitivity;

    private Float swipeVelocity = 0.0F;

    public Stick (Rect cube, int color, Bitmap[] stick, int deviceWidth, int deviceHeight) {

        this.stick = stick;
        this.color = color;
        stickCount = 0;
        stickSensitivity = 200;
        animationLimit = stickSensitivity;
        aanimationCounter = 0;

        position =  new PointF(deviceHeight / 2, deviceWidth / 2 + stick[0].getHeight());

    }

    @Override
    public void update() {

    }

    public void update(Float x, Float swipeVelocity) {

        if (swipeVelocity == getSwipeVelocity()) {
            swipeVelocity /= 10;
        }

        System.out.println(swipeVelocity);

        animationLimit = (int) (stickSensitivity / swipeVelocity);
        if(animationLimit < 0){
            animationLimit = -animationLimit;
        }
        if(swipeVelocity == 0){
            animationLimit = stickSensitivity;
        }

        if (swipeVelocity > 10) {
            direction = 1;
        }
        if (swipeVelocity < -10) {
            direction = -1;
        }
        if (swipeVelocity < 10 && swipeVelocity > -10) {
            direction = 0;
        }
        //System.out.println(playerVelocity);
        position.x = x;
        aanimationCounter++;
        if(aanimationCounter > animationLimit){
            stickCount += direction;
            if (stickCount < 0) {
                stickCount = 2;
            }
            if ( stickCount > 2 ) {
                stickCount = 0;
            }
            aanimationCounter = 0;
        }

        setSwipeVelocity(swipeVelocity);
    }

    public void setSwipeVelocity(Float swipeVelocity) {
        this.swipeVelocity = swipeVelocity;
    }

    public float getSwipeVelocity() {
        return this.swipeVelocity;
    }

    @Override
    public void draw(Canvas canvas) {
        Paint paint = new Paint();
        paint.setColor(color);
        //canvas.drawRect(cube, paint);
        canvas.drawBitmap(stick[stickCount],position.x,position.y,null);
    }
}
