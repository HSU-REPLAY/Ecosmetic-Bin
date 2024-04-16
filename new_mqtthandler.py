import paho.mqtt.client as mqtt
import requests
from requests.exceptions import RequestException
from requests_toolbelt.multipart.encoder import MultipartEncoder
import datetime

MQTT_BROKER = "localhost"
MQTT_PORT = 1883
CHECK_TOPIC = "check"
PRESENCE_TOPIC = "presence"
RESULT_TOPIC = "completion"
token = 'NThmNzkxMjYtMzU2MS00NzI0LWEyMmQtOTUyYzZjYTQ4MGQwMzZmMWFlNjYtMWE3_P0A1_3110228f-f720-43ec-9b4d-e218298566dd'

# 현재 사용자 ID 전역 변수
current_user_id = None

# 방을 찾거나 없으면 새로 생성하는 함수
def find_or_create_room(room_title):
    url = "https://webexapis.com/v1/rooms"
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        rooms = response.json().get('items', [])
        for room in rooms:
            if room['title'] == room_title:
                return room['id']
        return create_room(room_title)
    else:
        print("Failed to retrieve rooms:", response.text)

# Webex에서 새로운 방을 생성하는 함수    
def create_room(room_title):
    url = "https://webexapis.com/v1/rooms"
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    payload = {"title": room_title}
    response = requests.post(url, headers=headers, json=payload)
    if response.status_code == 200:
        room_id = response.json().get('id')
        return room_id
    else:
        print("Failed to create room:", response.text)

# 사용자를 방에 초대하는 함수
def invite_user_to_room(room_id, webex_id):
    url = f"https://webexapis.com/v1/memberships"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    payload = {
        "roomId": room_id,
        "personId": webex_id
    }
    response = requests.post(url, headers=headers, json=payload)
    if response.status_code == 200:
        print("User successfully invited to the room")
    else:
        print("Failed to invite user to the room:", response.text)

# Webex 방에 메시지를 보내는 함수
def send_webex_message(room_id, message):
    m = MultipartEncoder({
        'roomId': room_id,
        'text': message
    })
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': m.content_type
    }
    response = requests.post('https://webexapis.com/v1/messages', data=m, headers=headers)
    if response.status_code == 200:
        print("Message sent successfully")
    else:
        print("Failed to send message:", response.text)

# 데이터 전송 및 Webex 메시지 발송 함수
def send_data_to_webex(webex_id, plastic_count, can_count, glass_count, mileage):
    room_id = find_or_create_room("Ecostic Bin Recycling Room")
    if room_id:
        message = (
            "🌍 Ecostic Bin Recycling Summary 🌍\n"
            "----------------------------------------\n"
            f"👤 사용자: {webex_id}\n"
            f"♻️ 플라스틱: {plastic_count}개\n"
            f"♻️ 캔: {can_count}개\n"
            f"♻️ 유리: {glass_count}개\n"
            "=============================\n"
            f"💳 적립된 마일리지: {mileage}점\n\n"
            "\"당신의 소중한 노력에 감사드립니다.\n 지구가 숨 쉬고 있어요! 🌱\""
        )
        send_webex_message(room_id, message)
    else:
        print("Failed to find or create room.")


# 데이터 전송 함수
def send_data(user_id, webex_id, date, plastic_count, can_count, glass_count):
    server_result = 'http://192.168.137.1:8080/ecobin/result'
    params = {
        'userId': user_id,
        'date': date,
        'plasticCount': plastic_count,
        'canCount': can_count,
        'glassCount': glass_count
    }
    try:
        response = requests.get(server_result, params=params)
        if response.status_code == 200:
            print("Data successfully sent to server.")
            mileage = (plastic_count*30) + (can_count*10) + (glass_count * 20)
            print("Mileage:", mileage)  
            send_data_to_webex(webex_id, plastic_count, can_count, glass_count, mileage)
        else:
            print("Server response:", response.status_code)
    except RequestException as e:
        print("Server connection failed:", e)


# 사용자 ID 검증 함수
def verify_user(user_id):
    server_check = "http://192.168.137.1:8080/ecobin/check"
    try:
        response = requests.get(server_check, params={'userId': user_id})
        print("Server response:", response.text)  # 서버 응답 내용 출력
        if response.status_code == 200:
            # 텍스트 응답을 파싱하여 필요한 데이터 추출
            parts = response.text.split(", ")
            verified_part = parts[0].split(": ")[1]
            webex_id_part = parts[1].split(": ")[1]
            return (verified_part == "true", webex_id_part.strip())
        else:
            print("Error response from web server:", response.status_code)
            return (False, None)
    except requests.exceptions.RequestException as e:
        print("Exception during web server request:", e)
        return (False, None)

# 메시지 처리 함수    
def on_message(client, userdata, msg):
    global current_user_id  # 사용자 ID 전역 변수
    global current_webex_id  # Webex ID 전역 변수

    if msg.topic == CHECK_TOPIC:
        user_id = msg.payload.decode()
        verified, webex_id = verify_user(user_id)  # 튜플 분해

        print(f"사용자 ID : {user_id}, 검증 결과: {'맞음' if verified else '틀림'}, Webex ID: {webex_id if webex_id else '없음'}")

        if verified:
            current_user_id = user_id
            current_webex_id = webex_id
        else:
            current_user_id = None
            current_webex_id = None

        client.publish(PRESENCE_TOPIC, "true" if verified else "false")

    elif msg.topic == RESULT_TOPIC and current_user_id and current_webex_id:
        date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        msg_string = msg.payload.decode().split(",")
        plastic_count, can_count, glass_count = map(int, msg_string)
        # 사용자 ID와 Webex ID도 전달
        send_data(current_user_id, current_webex_id, date, plastic_count, can_count, glass_count)


def on_connect(client, userdata, flags, rc):
    client.subscribe(CHECK_TOPIC)
    client.subscribe(RESULT_TOPIC)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_forever()


