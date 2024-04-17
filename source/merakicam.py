import meraki
import requests

API_KEY = 'USER API KEY' 
dashboard = meraki.DashboardAPI(API_KEY)  # 본인 api 키를 이용해서 dashboard 접근
serial = 'Q2GV-GF7Q-9VQQ'  # 사용하고자 하는 메라키 카메라 시리얼넘버

def download_image(filename): 
    response = dashboard.camera.generateDeviceCameraSnapshot (  
        serial
    )
    print(response)
    url = response['url']
    response = requests.get(url)
    
    if response.status_code == 200:
        with open(filename, 'wb') as f:
            f.write(response.content)
        print("이미지 다운로드 완료")
    else:
        print("이미지를 다운로드할 수 없습니다.")

filename = "./image.jpg"  # 저장할 파일명