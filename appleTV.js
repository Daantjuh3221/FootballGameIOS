function AppleTV(id) {
  this.id = id;
  this.joinCode = null;
  this.player1 = null;
  this.players = [];
  this.teamRed = [];
  this.teamBlue = [];
  this.playerLimit = 4;
  this.status = "open";
};

AppleTV.prototype.addPlayer = function(playerID) {
  if (this.status === "open") {
    if (this.players.length === 0) {
      this.player1 = playerID;
      this.players.push(playerID);
      console.log("player 1 for AppleTV is defined with: " + this.player1)
    } else {
      this.players.push(playerID)
      console.log("A player had been added to the AppleTV");
    }
  }
};

AppleTV.prototype.joinRoom = function(roomID) {
  this.inRoom = roomID;
};

AppleTV.prototype.leaveRoom = function(roomID) {
  this.inRoom = null;
};

AppleTV.prototype.removePlayer = function(playerID) {
  var playerIndex = -1;
  for(var i = 0; i < this.controllers.length; i++){
    if(this.controllers[i].id === controller.id){
      playerIndex = i;
      break;
    }
  }
  this.players.remove(playerIndex);
};

AppleTV.prototype.getPlayer = function(playerID) {
  var player = null;
  for(var i = 0; i < this.players.length; i++) {
    if(this.players[i].id == personID) {
      player = this.players[i];
      break;
    }
  }
  return player;
};

AppleTV.prototype.isAvailable = function() {
  return this.available === "open";
};

module.exports = AppleTV;
