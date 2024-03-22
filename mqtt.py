import paho.mqtt.client as mqtt
import camocr

def on_connect(client, userdata, flag, rc):
    client.subscribe("login") # "login" 토픽으로 구독 신청
    # camocr.cam() # 함수 호출
    # new_payload = str("username") + ',' + camocr.getCnt()
    # 새로운 문자열을 새로운 토픽으로 발행
    # client.publish("push", new_payload)
      
#"login" 토픽으로 메세지가 날라오면 cam()함수 호출
def on_message(client, userdata, msg) :
    camocr.cam() # 함수 호출
    new_payload = str(msg.payload.decode()) + ',' + camocr.getCnt()
    # 새로운 문자열을 새로운 토픽으로 발행
    client.publish("push", new_payload)
    print("publish(\"push\", ", new_payload, ")")

ip = "localhost" # 현재 브로커는 이 컴퓨터에 설치되어 있음

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION1)
client.on_connect = on_connect
client.on_message = on_message

client.connect(ip, 1883) # 브로커에 연결
client.loop_forever() # 메시지 루프
