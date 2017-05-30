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

	console.log("Someone connected")

    socket.on('disconnect', function(reason){
        console.log("Socket disconnected beceause of: " + reason)
        if(checkIfUserExists(socket.id))
        {
            var playerToDelete = connectedPlayers[socket.id];
            console.log("Delete user");
            if (checkIfAppleTVExists(playerToDelete.inAppleTv)) {
                var appleTVModify = connectedAppleTvs[playerToDelete.inAppleTv];
                for(var i = 0; i < appleTVModify.players.length; i++){
                console.log("deleting user in appleTV: " + appleTVModify.players[i]);
                delete appleTVModify.players[i];
                console.log("deleted user in appleTV: " + appleTVModify.players[i]);
                console.log("deleted user by appleTV: " + appleTVModify);
                }
            }
            delete connectedPlayers[socket.id];
            console.log("deleted " + socket.id);
        } else{
            var indexForAppleTV = 0;
        	for(var joinCodeToDelete in connectedAppleTvs){
            console.log("deleting an appleTV");
                var deleteTV = connectedAppleTvs[joinCodeToDelete];
                console.log("The length of players in apple tv: " + deleteTV.players.length)
                for(var i = 0; i < deleteTV.players.length; i++){
                    var foundedPlayer = deleteTV.players[i];
                    console.log("founded player: " + foundedPlayer);
                    if (checkIfVarExist(foundedPlayer)) {
                        var deletingPlayer = connectedPlayers[foundedPlayer];
                        console.log("Deleted player: " + deletingPlayer);
                        io.to(deletingPlayer.socket).emit('disconnectFromAppleTV');
                        deletingPlayer.inAppleTv = null;
                        console.log("disconnected player: "+ deletingPlayer.name)
                    }
                }
                delete connectedAppleTvs[joinCodeToDelete];
                console.log("deleted apple tv: " + joinCodeToDelete);
                console.log("is appleTV deleted?: " + connectedAppleTvs[joinCodeToDelete]);
                indexForAppleTV++;
            }
        }
     });

	socket.on("newUserConnect", function(name, device){
		var exists = false
        var playerIndex = -1;

        for (var player in connectedPlayers) {
            if (name === connectedPlayers[player].name) {
                exists = true;
                break;
            }
    		playerIndex++;
        }
        if (!exists) {
            connectedPlayers[socket.id] = {"name" : name, "inAppleTv" : null, "device": device, "team": null, "socket": socket.id};
            sockets.push(socket);
            console.log("update, " + connectedPlayers[socket.id].name + " is online.");
        } else{
            console.log("Username " + name + " already exists!");
        }
        socket.emit("usernameExists", exists);

	});

	socket.on("developUserConnect", function(){
    	connectedPlayers[socket.id] = {"name" : "developer", "inAppleTv" : null, "device": device, "team": null, "socket": socket.id};
        console.log("update, " + connectedPlayers[socket.id].name + " is online.");
	});


	socket.on("registeredUserConnect", function(name, device){
		var exists = false
        var playerIndex = -1;
        for (var player in connectedPlayers) {
            if (name === connectedPlayers[player].name) {
                exists = true;
                connectedPlayers[socket.id] = connectedPlayers[player];
                connectedPlayers[socket.id].socket = socket.id;
                break;
            }
    		playerIndex++;
        }
        if (!exists) {
        	connectedPlayers[socket.id] = {"name" : name, "inAppleTv" : null, "device": device, "team": null, "socket": socket.id};
	        sockets.push(socket);
	        console.log("update, " + connectedPlayers[socket.id].name + " is online.");
        } 
        io.to(socket.id).emit("loginSucceeded", true);
	});

    socket.on("checkSocketID", function() {
        console.log(socket.id);
    });
    socket.on("connectAppleTV", function() {
        var joinCode = generateJoinCode();
        while(checkIfAppleTVExists(joinCode)){
            joinCode = generateJoinCode();
        }
        var newAppleTV = new AppleTV(socket.id);
        connectedAppleTvs[joinCode] = newAppleTV;
        console.log("update, an apple tv has connected. With joinCode: " + joinCode);
        socket.emit("getJoinCode", joinCode);
        
    });

    socket.on("newConnectAppleTV", function() {
        var joinCode = generateJoinCode();
        while(checkIfAppleTVExists(joinCode)){
            joinCode = generateJoinCode();
        }
        var newAppleTV = new AppleTV(socket.id);
        newAppleTV.joinCode = joinCode;
        connectedAppleTvs[joinCode] = newAppleTV;
        console.log("update, an apple tv has connected. With joinCode: " + joinCode);
        socket.emit("getJoinCode", joinCode);
        
    });

    socket.on("registeredConnectAppleTV", function(joinCode) {
        console.log("WE ZIJN HIER MET JOINCODE:" + connectedAppleTvs);
        var newAppleTV = new AppleTV(socket.id);
        newAppleTV.joinCode = joinCode;
        connectedAppleTvs[joinCode] = newAppleTV;
        console.log("update, an apple tv has connected. With joinCode: " + joinCode);
        socket.emit("getJoinCode", joinCode);
        
    });

    socket.on("addPlayer", function(team, playerName) {
        var player = connectedPlayers[socket.id];
        var appleTV = connectedAppleTvs[player.inAppleTv];
        if (team == "teamRed") {
            appleTV.teamRed.push(playerName);
        } else{
            appleTV.teamBlue.push(playerName);
        }
        //io.to(appleTV.id).emit("getTeams", teamBlue, teamRed);
        //io.to(appleTV.id).emit("startGameOnAppleTV");
        console.log("Team red: " + appleTV.teamRed + " team blue: " + appleTV.teamBlue);
    });

    socket.on("startGame", function() {
        var player = connectedPlayers[socket.id];
        var appleTV = connectedAppleTvs[player.inAppleTv];
        io.to(appleTV.id).emit("getTeams", appleTV.teamBlue, appleTV.teamRed);
        io.to(appleTV.id).emit("startGameOnAppleTV");
        console.log(appleTV.id + "Started a game")
    });

    socket.on("playLocal", function() {
        console.log("I want to play local");
        var player = connectedPlayers[socket.id];
        if (checkIfVarExist(player)) {
            var appleTV = connectedAppleTvs[player.inAppleTv];
            if (checkIfVarExist(appleTV)) {
                console.log(appleTV.players);
                for (var i = 0; i < appleTV.players.length; i++) {
                    if (appleTV.players[i] === socket.id) {
                    } else {
                        io.to(appleTV.players[i]).emit('startLocal');
                    }
                }
            }
            
        }
        
    });

    socket.on("chooseSideRed", function() {
        var player = connectedPlayers[socket.id];
        var appleTV = connectedAppleTvs[player.inAppleTv];
        console.log(player.name + " chose a side");
        for (var i = 0; i < appleTV.players.length; i++) {
        	console.log(appleTV.players[i] + " === " + socket.id);
        	if (appleTV.players[i] === socket.id) {
        		console.log("hetzelfde");
        	} else {
        		console.log("Niet hetzelfde");
        		io.to(appleTV.players[i]).emit('addPlayerToTeamRed', player.name);
        	}
        };
    });

    socket.on("chooseSideBlue", function() {
        var player = connectedPlayers[socket.id];
        var appleTV = connectedAppleTvs[player.inAppleTv];
        console.log(player.name + " chose a side");
        for (var i = 0; i < appleTV.players.length; i++) {
        	console.log(appleTV.players[i] + " === " + socket.id);
        	if (appleTV.players[i] === socket.id) {
        		console.log("hetzelfde");
        	} else {
        		console.log("Niet hetzelfde");
        		io.to(appleTV.players[i]).emit('addPlayerToTeamBlue', player.name);
        	}
        };

    });

    socket.on("chooseSideMidden", function() {
        var player = connectedPlayers[socket.id];
        var appleTV = connectedAppleTvs[player.inAppleTv];
        console.log(player.name + " chose a side");
        for (var i = 0; i < appleTV.players.length; i++) {
        	console.log(appleTV.players[i] + " === " + socket.id);
        	if (appleTV.players[i] === socket.id) {
        		console.log("hetzelfde");
        	} else {
        		console.log("Niet hetzelfde");
        		io.to(appleTV.players[i]).emit('addPlayerToTeamMidden', player.name);
        	}
        };
    });

    socket.on("userJoinAppleTV", function(joinCode) {
        var appleTV = connectedAppleTvs[joinCode];
        var exists = false;
        if (checkIfAppleTVExists(joinCode)) {

            appleTV.addPlayer(socket.id);
            
            if (socket.id === appleTV.player1) {
                io.to(socket.id).emit('isPlayerOne', true);
            } else {
            	//VERWIJDER
                io.to(socket.id).emit('isPlayerOne', false);
            }
            //io.to(socket.id).emit('isPlayerOne', isPlayerOne);
            var newPlayer = connectedPlayers[socket.id];
            newPlayer.inAppleTv = joinCode;
            exists = true;
            io.to(appleTV.id).emit('userJoinedAppleTV', newPlayer.name);
            console.log("AppleTV exists");
        } else {
            console.log("appleTV does not exists");
        }
        socket.emit("appleTvExists", exists);
    });


    socket.on("sendPositionYToAppleTV", function(positionY) {
        var player = connectedPlayers[socket.id];
        if (checkIfUserExists(socket.id)) {
                var appleTV = connectedAppleTvs[player.inAppleTv];
                if (checkIfAppleTVExists(player.inAppleTv)) {
                    io.to(appleTV.id).emit("getPositionYforAppleTV", positionY, player.name);
                } else{
                    console.log("Apple tv does not exist");
                }
            } else{
                console.log("User does not exist anymore");
            }
        });
    socket.on("sendPositionXToAppleTV", function(positionX) {
        var player = connectedPlayers[socket.id];
        if (checkIfUserExists(socket.id)) {
            var appleTV = connectedAppleTvs[player.inAppleTv];
            if (checkIfAppleTVExists(player.inAppleTv)) {
                io.to(appleTV.id).emit("getPositionXforAppleTV", positionX, player.name);
            } else{
                console.log("Apple tv does not exist");
            }
        } else{
            console.log("User does not exist anymore");
        }
        
    });

    // socket.on("createRoom", function(roomName) {
    //     var err = ""
    //     if (roomName != null) {
    //         socket.join(roomName);
    //         rooms.push(roomName);
    //         io.sockets.emit("getRooms", rooms);
    //     console.log("Room " + roomName + " created")
    //     } else{
    //         console.log("Fill in a name for the room");
    //     }
    // });
});

//FUNCTIONS OF THE APPLICATION
function generateJoinCode(){
    return Math.random().toString(36).substring(2, 8);
}

function checkIfAppleTVExists(appleTvJoinCode){
    var appleTV = connectedAppleTvs[appleTvJoinCode];
    if (typeof appleTV !== 'undefined' && appleTV !== null) { 
        return true;
    }
    return false;
}

function checkIfVarExist(item){
    if (typeof item !== 'undefined' && item !== null) { 
        return true;
    }
    return false;
}

function checkIfUserExists(socketId){
    var player = connectedPlayers[socketId];
    if (typeof player !== 'undefined' && player !== null) { 
        return true;
    }
    return false;
}

console.log("Starting Socket App - http://localhost:3000");