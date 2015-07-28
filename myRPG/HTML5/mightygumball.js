window.onload = function () {
	var button = document.getElementById('previewBtn');
	button.onclick = previewBtnClickedHandler;
}

function previewBtnClickedHandler () {
	var canvas = document.getElementById('tshirtCanvas');
	var context = canvas.getContext('2d');
	fillBackgroundColor(canvas, context);

	var selectObj = document.getElementById('shape');
	var index = selectObj.selectedIndex;
	var shape = selectObj[index].value;

	if (shape == "squares") {
		for (var i = 0; i < 20; i++) {
			drawSquare(canvas, context);
		}
	}
	else if (shape == "circles"){
		for (var i = 0; i < 20; i++) {
			drawCircle(canvas, context);
		}
	}
}

function fillBackgroundColor (canvas, context) {
	var selectObj = document.getElementById('backgroundColor');
	var index = selectObj.selectedIndex;
	var bgColor = selectObj.options[index].value;

	context.fillStyle = bgColor;
	context.fillRect(0, 0, canvas.width, canvas.height)
}

function drawSquare (canvas, context) {
	var w = Math.floor(Math.random() * 40);
	var x = Math.floor(Math.random() * canvas.width);
	var y = Math.floor(Math.random() * canvas.height);

	context.fillStyle = "lightblue";
	context.fillRect(x, y, w, w);
}

function drawCircle (canvas, context) {
	var w = Math.floor(Math.random() * 40);
	var x = Math.floor(Math.random() * canvas.width);
	var y = Math.floor(Math.random() * canvas.height);

	context.beginPath();
	context.arc(x, y, w, 0, degreesToRadians(270), false);

	context.fillStyle = "lightblue";
	context.fill();
}

function degreesToRadians (degrees) {
	return (degrees * Math.PI) / 180;
}
