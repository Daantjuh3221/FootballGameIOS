var express = require("express");
var http = require("http");
var app = express();
var server = http.createServer(app).listen(3000);
var io = require("socket.io")(server);
var Room = require("./room.js");
var AppleTV = require("./appleTV.js");
_ = require('underscore')._;
var uuid = require("node-uuid");

var rooms = [];
var connectedPlayers = [];
var connectedAppleTvs = [];
var sockets = [];

app.use(express.static("./public"));

io.on("connection", function(socket) {

    socket.on("connectUser", function(name, device) {
        var exists = false
        for (var player in connectedPlayers) {
            if (name === connectedPlayers[player].name) {
                exists = true;
            }
        }
        if (!exists) {
            connectedPlayers[socket.id] = {"name" : name, "inAppleTv" : null, "device": device};
            sockets.push(socket);
            console.log("update, " + connectedPlayers[socket.id].name + " is online.");
            socket.emit("usernameExists", exists);
        } else{
            socket.emit("usernameExists", exists);
            console.log("Username " + name + " already exists!");
        }
        
    });


    socket.on("checkSocketID", function() {
        console.log(socket.id);
    });
    socket.on("connectAppleTV", function() {
        var joinCode = Math.random().toString(36).substring(2, 8);
        var newAppleTV = new AppleTV(socket.id);
        connectedAppleTvs[joinCode] = newAppleTV;
        console.log("update, an apple tv has connected. With joinCode: " + joinCode);
        socket.emit("getJoinCode", joinCode);
    });


    socket.on("userJoinAppleTV", function(joinCode) {
        var appleTV = connectedAppleTvs[joinCode];
        var exists = false;
        if (typeof appleTV !== 'undefined' && appleTV !== null) { 
            appleTV.addPlayer(socket.id);
            console.log(appleTV.id);
            io.to(appleTV.id).emit('someoneConnected', 'Hooi ' + connectedPlayers[socket.id].name);
        } else if(joinCode !== "1234"){
            exists = true;
        }
        socket.emit("appleTvExists", exists);
    });


    socket.on("sendPositionY", function(positionY) {
        io.sockets.emit("getPositionY", positionY);
    });
    socket.on("sendPositionX", function(positionX) {
        io.sockets.emit("getPositionX", positionX);
    });

    socket.on("createRoom", function(roomName) {
        var err = ""
        if (roomName != null) {
            socket.join(roomName);
            rooms.push(roomName);
            io.sockets.emit("getRooms", rooms);
        console.log("Room " + roomName + " created")
        } else{
            console.log("Fill in a name for the room");
        }
    });
});

console.log("Starting Socket App - http://localhost:3000");