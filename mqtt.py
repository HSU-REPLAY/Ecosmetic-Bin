#mqtt.py
import paho.mqtt.client as mqtt
import ocr
import io, time
import cv2
from PIL import Image, ImageFilter
import cv2
import camera
import base64
import json
from database import check_user_exists

isStart  = False

def on_connect(client, userdata, flag, rc):
    client.subscribe("check") # 통신 서버 모듈에서 실행하도록 수정 해야함
    client.subscribe("streaming")  # "streaming" 토픽으로 구독 신청
    client.subscribe("capture")  # "capture" 토픽으로 구독 신청
      
def on_message(client, userdata, msg):
    if msg.topic == "check": # 통신 서버 모듈에서 실행하도록 수정 해야함
        # 사용자 ID 확인 로직
        user_id = msg.payload.decode()
        user_exists = check_user_exists(user_id)
        client.publish("presence", "true" if user_exists else "false")

    elif msg.topic == "streaming":
        global isStart
        if msg.payload.decode() == 'start':
            print("Start Stream")
            isStart = True
        else:
            print("Stop Stream")
            isStart = False
            pass

    elif msg.topic == "capture":
        # 사용자가 'start' 버튼을 누르고, 사용자가 존재한다면 카메라 작동  
        frame = camera.take_picture()
        image_path = 'image.jpg'
        cv2.imwrite(image_path, frame) # 이미지를 캡처하여 'image.jpg' 파일로 저장한다.
        print("Image saved successfully.")

        ocr.ocr(image_path) # 카메라를 활성화하는 함수를 호출
        
        # 새로운 문자열을 새로운 토픽으로 발행
        client.publish("result", ocr.getCnt())
        print("publish(\"result\", ", ocr.getCnt(), ")")

ip = "localhost" # 현재 브로커는 이 컴퓨터에 설치되어 있음

client = mqtt.Client()
#mqtt version 오류가 나온다면 client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION1) 로 수정
client.on_connect = on_connect
client.on_message = on_message

client.connect(ip, 1883) # 브로커에 연결

client.loop_start() # 메시지 루프를 실행하는 스레드 생성

camera.init()
stream = io.BytesIO()

while True:
	if isStart == True:
		image = camera.take_picture(most_recent=True)  # 사진 촬영. 이미지 읽기
		if image is not None:
			bytes = cv2.imencode(".jpg", image)[1].tobytes()
			base64_image = base64.b64encode(bytes) # base64로 인코딩

        # 이미지를 MQTT 토픽에 publish
		client.publish("image", base64_image)

camera.release() # 카메라 사용 끝내기
client.loop_stop() # 메시지 루프를 실행하는 스레드 종료
client.disconnect()

