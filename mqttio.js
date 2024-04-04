let client = null; // MQTT 클라이언트의 역할을 하는 Client 객체를 가리키는 전역변수
let connectionFlag = false; // 연결 상태이면 true
let userName;

function startConnect() { // 브로커에 접속하는 함수
	// 재로그인 시도 시
	if(connectionFlag == true) {
		subscribe("presence"); // 'presence' 토픽 구독
		publish("check", userName); // 'check' 토픽으로 사용자 ID 발행
	}

	let broker = "localhost";
	let port = 9001;
	
	userName = document.getElementById("inputName").value.trim();

	// MQTT 메시지 전송 기능을 모두 가징 Paho client 객체 생성
	client = new Paho.MQTT.Client(broker, Number(port), userName);

	// client 객체에 콜백 함수 등록 및 연결
	client.onConnectionLost = onConnectionLost; 
	client.onMessageArrived = onMessageArrived;

	// client 객체에게 브로커에 접속 지시
	client.connect({
		onSuccess: function () {
			document.getElementById("messages").innerHTML = '<span>connected</span><br/>';
			connectionFlag = true;
			document.getElementById("ecoIcon").src = "./recycleIcon.svg";
			document.getElementById("screenStyleSheet").setAttribute('href', 'mainScreen.css');
			subscribe("presence"); // 'presence' 토픽 구독
			publish("check", userName); // 'check' 토픽으로 사용자 ID 발행
		},
		onFailure: function (error) {
			document.getElementById("messages").innerHTML = `<span>Connection failed: ${error.errorMessage}</span><br/>`;
            connectionFlag = false;
		}
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
	//document.getElementById("messages").innerHTML = '<span>메세지 도착: ' + msg.payloadString + '</span><br>';
	if(msg.destinationName == "presence") {
		if(msg.payloadString == "false") {
			unsubscribe("presence");
			userName = "";
			document.getElementById("loginError").style.visibility = "visible";
			document.getElementById("userName").style.color = "red";
			document.getElementById("loginButton").style.color = "red";
		}
		else if(msg.payloadString == "true") {
			document.getElementById("userName").innerHTML += "<b>" + userName + "</b>";
			document.getElementById("inputName").style.display = "none";
			document.getElementById("loginButton").style.display = "none";
			document.getElementById("loginError").style.visibility = "hidden";
			document.getElementById("operateButton").innerHTML = "start";
			for (let i = 0; i < hiddenItems.length; i++) {
				hiddenItems[i].style.display = "inline";
			}
			for (let i = 0; i < tables.length; i++) {
				tables[i].style.display = "inline-table";
			}
			document.getElementById("total").innerHTML = "배출량: " + total;
			startStreaming();
		}
	}
	else if(msg.destinationName == "image") {
		//console.log(“received”)
		// drawImage(msg.payloadString); // 메시지에 담긴 파일 이름으로 drawImage() 호출. drawImage()는 웹 페이지에 있음
		document.getElementById("merakiCam").src = msg.payloadString;
    }
	else if(msg.destinationName == "result") {
		let msgString = msg.payloadString.split(",");
		let plasticCount = parseInt(msgString[0]);
		let canCount = parseInt(msgString[1]);
		let glassCount = parseInt(msgString[2]);

		showResultDialog(plasticCount, canCount, glassCount);
	}
	document.getElementById("total").innerHTML = "배출량: " + total;
}

// disconnection 버튼이 선택되었을 때 호출되는 함수
function startDisconnect() {
	if(connectionFlag == false) 
		return; // 연결 되지 않은 상태이면 그냥 리턴
	stopStreaming();
	document.getElementById("ecoIcon").src = "./earth.png";
	document.getElementById("screenStyleSheet").setAttribute('href', 'homeScreen.css');
	document.getElementById("loginButton").style.display = "inline";
	document.getElementById("userName").innerHTML = "사용자 ID ";
	document.getElementById("inputName").style.display = "inline";
	document.getElementById("inputName").value = "";
	let hiddenItems = document.getElementsByClassName("hidden");
	for (let i = 0; i < hiddenItems.length; i++) {
		hiddenItems[i].style.display = "none";
	}
	client.disconnect(); // 브로커와 접속 해제
	document.getElementById("messages").innerHTML = '<span>연결종료</span><br/>';
	connectionFlag = false; // 연결 되지 않은 상태로 설정
}

function showResultDialog(plasticCount, canCount, glassCount) {
	let dialog = document.createElement('div');
    dialog.classList.add('dialog');
    
    // 다이얼로그 내용을 구성합니다.
    let content = `
        <p>플라스틱 개수: ${plasticCount}</p>
        <p>캔 개수: ${canCount}</p>
        <p>유리 개수: ${glassCount}</p>
        <button onclick="checkOcrResult(true)">OK</button>
        <button onclick="checkOcrResult()">재촬영</button>
    `;
    dialog.innerHTML = content;
    
    // 다이얼로그를 화면에 표시합니다.
    document.body.appendChild(dialog);
}

function showMileageDialog(mileage) {
	let dialog = document.createElement('div');
	dialog.classList.add('dialog');

	let content = `
		<p>${mileage} 마일리지 적립!</p>
	`;
	dialog.innerHTML = content;

	document.body.appendChild(dialog);
}

function checkOcrResult(okPressed = false) {
	if(okPressed === true) {
		// OK 버튼을 눌렀을 경우에만 변화된 값 확인 및 total 업데이트
		if(plasticCount == 1) {
			total++;
			intervalId = setInterval(function() {
				moveImageDown('plastic', './plastic.png');
			}, 300);
		} else if(canCount == 1) {
			total++;
			intervalId = setInterval(function() {
				moveImageDown('can', './can.png');
			}, 300);
		} else if(glassCount == 1) {
			total++;
			intervalId = setInterval(function() {
				moveImageDown('glass', './glass.png');
			}, 300);
		}
	}
	// 재촬영 버튼을 눌렀을 경우
	else if(okPressed === false){
		publish("capture", "true"); // 캡처하기 위해 'capture' 토픽으로 메시지 발행
	}
}