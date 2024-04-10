function keyClicked(key) {
	var keyValue = key.value;
	var inputName = document.getElementById("inputName");
	if(keyValue==" space "){
		inputName.value += " ";
	}
	else if(keyValue == "◀-") {
		inputName.value = inputName.value.slice(0, -1);
	}
	else if(keyValue == " enter ") {
		document.getElementById("virtualKeyboardContainer").style.visibility = "hidden";
	}
	else {
		inputName.value += keyValue;
	}
}