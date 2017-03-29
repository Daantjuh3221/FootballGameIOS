
var socket = io("http://127.0.0.1:33333");
var positiony = 0;


socket.on("disconnect", function() {
	setTitle("Disconnected");
});

socket.on("getRooms", function(allRooms, err) {
    clearBox("div.rooms");
    $.each(allRooms, function( index, value ) {
        printRooms(value);
    });
});

socket.on("connect", function() {
	setTitle("Connected to Cyber Chat");
});

socket.on("message", function(message) {
	printMessage(message);
});


$(document).ready(function() {
    $("#btnCreateRoom").click(function() {
        var roomName = $("#roomName").val();;
        //alert(roomName);
        positiony += 10;
        socket.emit("message", positiony);
    });
});

document.forms[0].onsubmit = function () {
    var input = document.getElementById("message");
    printMessage(input.value);
    socket.emit("chat", input.value);
    input.value = '';
};

function setTitle(title) {
    document.querySelector("h1").innerHTML = title;
}

function printMessage(message) {
    var p = document.createElement("p");
    p.innerText = message;
    document.querySelector("div.messages").appendChild(p);
}

function clearBox(element)
{
    document.querySelector(element).innerHTML = "";
}

function printRooms(message) {
    var p = document.createElement("p");
    p.innerText = message;
    var divRooms = document.querySelector("div.rooms");
    divRooms.appendChild(p);

}
