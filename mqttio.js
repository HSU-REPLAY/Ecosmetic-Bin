let client = null; // MQTT 클라이언트의 역할을 하는 Client 객체를 가리키는 전역변수
let connectionFlag = false; // 연결 상태이면 true
let userName;

function startConnect() { // 브로커에 접속하는 함수
	if(connectionFlag == true)
		return; // 현재 연결 상태이므로 다시 연결하지 않음

	let broker = "localhost";
	let port = 9001;

	userName = document.getElementById("getUserName").value.trim();
	document.getElementById("userName").innerHTML += userName;
	document.getElementById("getUserName").style.display = "none";
	document.getElementById("loginButton").style.display = "none";
	document.getElementById("operateButton").innerHTML = "start";
	for (let i = 0; i < hiddenItems.length; i++) {
		hiddenItems[i].style.display = "inline";
	}
	
	for (let i = 0; i < tables.length; i++) {
		tables[i].style.display = "inline-table";
	}
	document.getElementById("total").innerHTML = "배출량: " + total;

	// MQTT 메시지 전송 기능을 모두 가징 Paho client 객체 생성
	client = new Paho.MQTT.Client(broker, Number(port), userName);

	// client 객체에 콜백 함수 등록 및 연결
	client.onConnectionLost = onConnectionLost; 
	client.onMessageArrived = onMessageArrived;

	// client 객체에게 브로커에 접속 지시
	client.connect({
		onSuccess:onConnect, // 브로커로부터 접속 응답 시 onConnect() 실행
	});
}

// 브로커로의 접속이 성공할 때 호출되는 함수
function onConnect() {
	document.getElementById("messages").innerHTML = '<span>connected' + '</span><br/>';
	connectionFlag = true; // 연결 상태로 설정
}

function subscribe(topic) {
	if(connectionFlag != true) { // 연결되지 않은 경우
		document.getElementById("messages").innerHTML = '<span>연결되지 않았음</span><br/>';
		return false;
	}

	// 구독 신청하였음을 <div> 영역에 출력
	document.getElementById("messages").innerHTML = '<span>구독신청: 토픽 ' + topic + '</span><br/>';
	client.subscribe(topic); // 브로커에 구독 신청
}

function publish(topic, msg) {
	if(connectionFlag != true) { // 연결되지 않은 경우
		document.getElementById("messages").innerHTML = "연결되지 않았음";
		return false;
	}
	client.send(topic, msg, 0, false);
}

function unsubscribe(topic) {
	if(connectionFlag != true) return; // 연결되지 않은 경우
	
	document.getElementById("messages").innerHTML = '<span>구독신청취소: 토픽 ' + topic + '</span><br/>';
	client.unsubscribe(topic, null); // 브로커에 구독 신청 취소
}

// 접속이 끊어졌을 때 호출되는 함수
function onConnectionLost(responseObject) { // responseObject는 응답 패킷
	document.getElementById("messages").innerHTML = '<span>오류 : 접속 끊어짐</span><br/>';
	if (responseObject.errorCode !== 0) {
		document.getElementById("messages").innerHTML = '<span>오류 : ' + responseObject.errorMessage + '</span><br/>';
	}
	connectionFlag = false; // 연결 되지 않은 상태로 설정
}

// 메시지가 도착할 때 호출되는 함수
function onMessageArrived(msg) { // 매개변수 msg는 도착한 MQTT 메시지를 담고 있는 객체
	
	let dataString = JSON.parse(msg.payloadString);
	var plasticCount = dataString.plastic_count;
    var canCount = dataString.can_count;
    var glassCount = dataString.glass_count;
	document.getElementById("messages").innerHTML = '<span>메세지 도착: ' + msg.destinationName  + '플라스틱 수: ' + plasticCount + ', 캔 수: ' + canCount + ', 유리 수: ' + glassCount + '</span><br/>';
	total = plasticCount + canCount + glassCount;
	if(plasticCount > 0) {
		intervalId = setInterval(function() {moveImageDown('plastic', './1.png');}, 300);
		plasticCount--;
	}
	if(glassCount > 0) {
		intervalId = setInterval(function() {moveImageDown('glass', './2.png');}, 300);
		glassCount--;
	}
	if(canCount > 0) {
		intervalId = setInterval(function() {moveImageDown('aluminium', './1.png');}, 300);
		canCount--;
	}
	document.getElementById("total").innerHTML = "배출량: " + total;
}

// disconnection 버튼이 선택되었을 때 호출되는 함수
function startDisconnect() {
	if(connectionFlag == false) 
		return; // 연결 되지 않은 상태이면 그냥 리턴

	init();
	document.getElementById("loginButton").style.display = "inline";
	document.getElementById("userName").innerHTML = "사용자 이름: ";
	document.getElementById("getUserName").style.display = "inline";
	document.getElementById("getUserName").value = "";
	let hiddenItems = document.getElementsByClassName("hidden");
	for (let i = 0; i < hiddenItems.length; i++) {
		hiddenItems[i].style.display = "none";
	}
	let tables = document.getElementsByClassName("trashbin");
	for (let i = 0; i < tables.length; i++) {
		tables[i].style.display = "none";
	}

	client.disconnect(); // 브로커와 접속 해제
	document.getElementById("messages").innerHTML = '<span>연결종료</span><br/>';
	connectionFlag = false; // 연결 되지 않은 상태로 설정
}