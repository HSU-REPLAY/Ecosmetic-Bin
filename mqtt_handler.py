import paho.mqtt.client as mqtt
import json
import requests
from requests.exceptions import RequestException
#import mysql.connector
#from mysql.connector import Error

MQTT_BROKER = "localhost"
MQTT_PORT = 1883
CHECK_TOPIC = "check"
PRESENCE_TOPIC = "presence"
RESULT_TOPIC = "result"

# 현재 사용자 ID 전역 변수
current_user_id = None

# 데이터 전송 함수
def send_data(user_id, plastic_count, can_count, glass_count):
    server_url = '노트북 ip:8080/프로젝트이름/data'
    params = {
        'userId': user_id,
        'plasticCount': plastic_count,
        'canCount': can_count,
        'glassCount': glass_count
    }
    try:
        response = requests.get(server_url, params=params)
        # 응답 내용 확인
        if response.text == "OK":
            print("Data successfully sent to server.")
        else:
            print("Server response:", response.text)
    except RequestException as e:
        print("Server connection failed:", e)

# 사용자 ID 존재 확인 함수(가상)
def check_user_exists(user_id):
    return user_id in ["user1", "user2", "user3"]

def on_message(client, userdata, msg):
    global current_user_id  # 전역 변수 사용
    
    if msg.topic == CHECK_TOPIC:
        user_id = msg.payload.decode()
        user_exists = check_user_exists(user_id)
        
        # 사용자가 존재하면 전역 변수에 ID 저장
        if user_exists:
            current_user_id = user_id  # 사용자 ID 저장

        client.publish(PRESENCE_TOPIC, "true" if user_exists else "false")

    elif msg.topic == RESULT_TOPIC and current_user_id:
        try:
            msg_string = msg.payload.decode().split(",")
            plastic_count = int(msg_string[0])
            can_count = int(msg_string[1])
            glass_count = int(msg_string[2])
            # 파싱된 데이터를 사용하여 서버로 데이터 전송
            send_data(current_user_id, plastic_count, can_count, glass_count)
        except ValueError:
            print("Error parsing RESULT_TOPIC message")
        except IndexError:
            print("RESULT_TOPIC message format error")

def on_connect(client, userdata, flags, rc):
    client.subscribe(CHECK_TOPIC)
    client.subscribe(RESULT_TOPIC) 

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)

client.loop_forever()

