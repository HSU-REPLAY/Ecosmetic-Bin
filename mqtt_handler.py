import paho.mqtt.client as mqtt
import requests
import datetime
from requests.exceptions import RequestException

MQTT_BROKER = "localhost"
MQTT_PORT = 1883
CHECK_TOPIC = "check"
PRESENCE_TOPIC = "presence"
RESULT_TOPIC = "completion"


# 현재 사용자 ID 전역 변수
current_user_id = None

# 데이터 전송 함수
def send_data(user_id, date, plastic_count, can_count, glass_count):
    print("함수들어왔?")
    server_result = 'http://172.20.10.4:8080/ecobin/result'
    params = {
        'userId': user_id,
        'date' : date,
        'plasticCount': plastic_count,
        'canCount': can_count,
        'glassCount': glass_count
    }
    try:
        print("response 전")
        response = requests.get(server_result, params=params)
        print("response 후")#
        if response.status_code == 200:
            print("Data successfully sent to server.")
        else:
            print("Server response:", response.status_code)
    except RequestException as e:
        print("Server connection failed:", e)

# 웹 서버에 사용자 ID 검증
def verify_user(user_id):
    print("함수들어왔?")
    server_check = "http://172.20.10.4:8080/ecobin/check"
    try:
        print("????")
        response = requests.get(server_check, params={'userId': user_id})
        if response.status_code == 200:
            print("response")
            return response.text  # "true" 또는 "false"
        else:
            print("Error response from web server:", response.status_code)
            return "false"
    except requests.exceptions.RequestException as e:
        print("Exception during web server request:", e)
        return "false"

def on_message(client, userdata, msg):
    global current_user_id
    if msg.topic == CHECK_TOPIC:
        user_id = msg.payload.decode()
        # 웹 서버에 사용자 ID 검증 요청
        print("사용자 id : " + user_id)
        verification_result = verify_user(user_id)
        print("맞니? : " + verification_result)
        if verification_result == "true":
            current_user_id = user_id
        # PRESENCE_TOPIC에 검증 결과 발행
        client.publish(PRESENCE_TOPIC, verification_result)

    elif msg.topic == RESULT_TOPIC and current_user_id:
        
        date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print("time:", date)
        msg_string = msg.payload.decode().split(",")
        plastic_count, can_count, glass_count = map(int, msg_string)
        send_data(current_user_id, date, plastic_count, can_count, glass_count)#

def on_connect(client, userdata, flags, rc):
    client.subscribe(CHECK_TOPIC)
    client.subscribe(RESULT_TOPIC)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_forever()