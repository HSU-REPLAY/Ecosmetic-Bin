// 전역 변수 선언
let canvas;
let context;
let img;
let isImageSubscribed = false; // (확인) 꼭 필요한 변수인가

// load 이벤트 리스너 등록. 웹페이지가 로딩된 후 실행
window.addEventListener("load", function () {
    canvas = document.getElementById("camStreaming");
    context = canvas.getContext("2d");
    img = new Image();
    img.onload = function () {
        context.drawImage(img, 0, 0, canvas.width, canvas.height); // (0,0) 위치에 img 의 크기로 그리기
    }
});

// drawImage()는 "image' 토픽이 도착하였을 때 onMessageArrived()에 의해 호출된다.
function drawImage(base64_image) { // bytes 는 서버로부터 받은 JPEG 이미지 바이너리 형태
    img.src = 'data:image/jpeg;base64,' + base64_image;
}

function startStreaming() { 
    if(!isImageSubscribed) {
        subscribe('image'); // 토픽 image 등록
        isImageSubscribed = true;
    }
    publish('streaming', 'start'); // 토픽: streaming, 값: start 메시지 전송. 카메라 촬영 후 JPEG 이미지 보내도록 지시
}

function stopStreaming() {
    if(isImageSubscribed) {
        unsubscribe('image'); // 토픽 image 등록
        isImageSubscribed = false;
    }
    publish('streaming', 'stop'); // 토픽: streaming, 값: stop 메시지 전송. 스트리밍 중지
    clearCanvas(); // 캔버스 초기화
}

function clearCanvas() {
    // 캔버스를 지우기 위해 캔버스의 크기에 맞는 사각형을 그리고, 이미지 소스를 비움
    context.clearRect(0, 0, canvas.width, canvas.height);
    img.src = '';
}