#mqtt.py
import paho.mqtt.client as mqtt
import camocr

def on_connect(client, userdata, flag, rc):
    client.subscribe("check")  # "check" 토픽으로 구독 신청
    client.subscribe("start_camera")  # "start_camera" 토픽으로 구독 신청
      
def on_message(client, userdata, msg):
    if msg.topic == "check":
        # 사용자 ID 확인 로직
        user_id = msg.payload.decode()
        user_exists = check_user_exists(user_id)
        client.publish("exist", "true" if user_exists else "false")

    elif msg.topic == "start_camera":
        # 'start' 버튼을 누르고, 사용자가 존재하면 카메라 작동
        camocr.cam()  # 카메라를 활성화하는 함수
        new_payload = str(msg.payload.decode()) + ',' + camocr.getCnt()
	# 새로운 문자열을 새로운 토픽으로 발행
        client.publish("push", new_payload)
        print("publish(\"push\", ", new_payload, ")")

# 가상DB - 실제 DB 로직으로 대체해야함
def check_user_exists(user_id):
    return user_id in ["user1", "user2", "user3"]

ip = "localhost" # 현재 브로커는 이 컴퓨터에 설치되어 있음

client = mqtt.Client()
#mqtt version 오류가 나온다면 client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION1) 로 수정
client.on_connect = on_connect
client.on_message = on_message

client.connect(ip, 1883) # 브로커에 연결
client.loop_forever() # 메시지 루프

