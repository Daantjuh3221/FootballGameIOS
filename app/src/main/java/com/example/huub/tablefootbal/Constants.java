package com.example.huub.tablefootbal;

import java.util.List;

/**
 * Created by Lars on 29-3-2017.
 */

public class Constants {
    public static String USERNAME = "";
    public static boolean firstTime = false;
    public static boolean isPlayerOne = false;
    public static boolean isLogedin = false;
    public static boolean isConnectedAppleTV = false;
    public static boolean isConnectedServer = false;
    public static String JOINCODE = "Not defined";
    public static String JOINEDTEXT = "Joined";
    public static String DISCONNECTEDTEXT = "Disconnected";
    public static final String SERVER_URL = "http://192.168.137.15:3000";
    public static final String DEVICE = "Android";
    public static List TEAMBLUE;
    public static List TEAMRED;
    public static final String PREFERENCEFILENAME = "OverallPreferences";
    public static final int VIBRATIONDEFAULT = 50;
    public static final long [] VIBRATIONGOAL = {0, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 1000};
    public static final long [] VIBRATIONLOSE = {0, 250, 500, 250, 500, 1000};
}
