function Room(name, id, owner) {
  this.name = name;
  this.id = id;
  this.owner = owner;
  this.players = [];
  this.peopleLimit = 4;
  this.status = "available";
  this.private = false;
};

Room.prototype.addPerson = function(personID) {
  if (this.status === "available") {
    this.players.push(personID);
  }
};

Room.prototype.removePerson = function(person) {
  var personIndex = -1;
  for(var i = 0; i < this.players.length; i++){
    if(this.players[i].id === person.id){
      personIndex = i;
      break;
    }
  }
  this.players.remove(personIndex);
};

Room.prototype.getPerson = function(personID) {
  var person = null;
  for(var i = 0; i < this.players.length; i++) {
    if(this.players[i].id == personID) {
      person = this.players[i];
      break;
    }
  }
  return person;
};

Room.prototype.isAvailable = function() {
  return this.available === "available";
};

Room.prototype.isPrivate = function() {
  return this.private;
};

module.exports = Room;
