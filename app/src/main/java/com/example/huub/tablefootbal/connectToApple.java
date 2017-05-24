package com.example.huub.tablefootbal;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import io.socket.client.Socket;

public class connectToApple extends Fragment {


    private Socket mSocket;

    private TextView txtJoinCode;
    private Button btnJoinCode;

    public static connectToApple newInstance() {
        return new connectToApple();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_connect_to_apple, container, false);
        SocketConnection app = (SocketConnection) getActivity().getApplication();
        mSocket = app.getSocket(super.getContext());
        txtJoinCode = (TextView) view.findViewById(R.id.txtJoinCode);
        btnJoinCode = (Button) view.findViewById(R.id.btnJoinCode);

        btnJoinCode.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String joinCode = txtJoinCode.getText().toString();
                Constants.JOINCODE = joinCode;
                mSocket.emit("userJoinAppleTV", joinCode);
            }
        });

        return view;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

//    public void btnClicked(View v){
//        String joinCode = txtJoinCode.getText().toString();
//        mSocket.emit("userJoinAppleTV", joinCode);
//    }


}
