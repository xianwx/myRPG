window.onload = getMyLocation;
function getMyLocation () {
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPostion(displayLocation);
	} else{
		alert("no geolocation support");
	};
}

function displayLocation (position) {
	alert("displayLocation");
	var latitude = position.coords.latitude;
	var longitude = position.coords.longitude;

	var div = displayLocation.getElementById('location');
	div.innerHTML = "You are at latitude: " + latitude + ", longitude: " + longitude;
}
