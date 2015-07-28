function handleButtonClick () {
	var textInp = document.getElementById('songTextInp');
	var songName = textInp.value;
	if (songName == "") {
		alert("Please enter a song name.");
	} else{
		var li = document.createElement("li");
		li.innerHTML = songName;
		var ul = document.getElementById('playlist');
		ul.appendChild(li);
		save(songName);
	};
}

function init () {
	var button = document.getElementById('addBtn');
	button.onclick = handleButtonClick;
	loadPlaylist();
}


window.onload = init;
