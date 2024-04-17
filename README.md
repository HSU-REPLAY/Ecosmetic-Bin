# 🌏 Ecosmetic-Bin
![soft](https://capsule-render.vercel.app/api?type=soft&color=auto&text=2024%20Cisco%20Innovation%20Challenge%20Hackathon&fontSize=35&animation=twinkling)
<br>

## 🖥️ 프로젝트 소개
지능형 분리수거함을 포함하여 사용자별 화장품 마일리지를 적립하여 사용자가 스마트폰으로 언제든지 분리 배출 목록과 마일리지를 확인할 수 있는 선순환 구조의 IoT 시스템 입니다.
<br>

## 🕰️ 개발 기간
* 24.03.18 - 24.04.17
<br>

## 🧑‍🤝‍🧑 맴버구성
 - PM  : [박채원](https://github.com/muppychae1) - 프로젝트 전반 관리
 - 팀원1 : [양승연](https://github.com/YseungY) - mqtt 통신 모듈, cisco api 구현
 - 팀원2 : [하여린](https://github.com/niroey) - 웹 서버 구현 및 데이터베이스 구축
 - 팀원3 : [윤단비](https://github.com/yoondanbi) - 안드로이드 앱 구현
 - 팀원4 : [전아린](https://github.com/flsrinn) - Electron 프레임워크를 활용한 터치 스크린 구현
 - 팀원5 : [김은비](https://github.com/ssilverrain) - RaspberryPi를 이용한 AI 소프트웨어 개발 및 테스팅
 - 팀원6 : [이동건](https://github.com/mvg01) - RaspberryPi를 이용한 AI 소프트웨어 개발 및 테스팅
<br>

 ## ⚙️ 개발 환경
- `LINUX`
- `python 3.9.2`
- `JDK 20`
- **IDE** : Eclipse, Visual Studio, Android Studio
- **Framework** : Electron(29.2.0)
- **Database** : MySql DB(8.0)
- **Server**: Apache Tomcat (10.1)
- **Remote desktop tool** : PuTTY, RealVNC Viewer
<br>

## 🔧 아키텍처
![KakaoTalk_20240418_004830187](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/85239dda-b55e-4f10-bb97-afdbff6ee645)
<br>

## 💝 주요 기능
- AI 키오스크를 사용해서 MQTT 프로토콜을 통해 로그인 과정을 진행합니다. Eco 웹서버의 데이터베이스에서 사용자의 아이디를 찾은 후 로그인을 진행합니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/a6821d87-cca7-4389-a59a-a6fa92ba10f5)


- 로그인에 성공하고 처음 분류를 시작하는 경우에는, ‘HD Webcam’이 자동으로 선택됩니다. 라즈베리 파이의 USB 포트에 연결된 웹 캠을 통해 촬영된 영상을 AI 키오스크에서 실시간으로 확인할 수 있습니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/a72cf788-150e-4444-a9aa-64d48b727c96)

- MQTT 통신을 이용한 실시간 스트리밍 과정입니다. OpenCV를 사용하여 JPEG으로 만든 후 각 프레임을 base64로 인코딩 합니다. UI 모듈에서 다시 각 프레임을 base64로 디코딩하여 AI 키오스크에 그리는 방식을 통해 구현했습니다. 

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/c6868805-cd6b-4869-8ce8-0728342d36ab)

- 웹캠을 통한 촬영은 OpenCV의 VideoCapture 객체를 사용해 직접 사진을 촬영하고 이를 파일로 저장합니다. 

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/72cb9bc9-76cc-4195-b05f-1ea26d752724)


- Cisco의 Meraki camera는 다음과 같은 과정으로 촬영을 진행합니다. 

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/7d699a54-b61c-43e2-9df9-c792b30c5aaa)

- AI 엔진은 먼저 OCR 라이브러리인 PyTesseract를 사용하여 촬영된 이미지로부터 ‘Plastic’, ‘Glass’, ‘Can’이 적힌 용기들을 분류하고 용기의 개수를 세준 후 결과 메시지를 UI에게 전송해 줍니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/60f85a0b-2f06-40d1-8ce5-a1ab41bcc638)



![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/5cb9e45d-6ace-4753-b4d2-444d6fdec0ad)


- 안드로이드 Eco앱 초기화면

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/712f591e-9767-4e61-942b-bd9991be623c)

- 왼쪽은 회원가입 화면입니다. 사용자는 Eco 웹 서버 ID와 Webex ID를 입력하여 회원으로 가입합니다. Eco 웹 서버는 수신한 사용자 ID와 Webex ID를 user 테이블과 webex 테이블에 기록합니다. <br>
Webex ID는 추후 사용자가 키오스크에서 분리 배출을 할 때 알림을 받기 위해 사용됩니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/58346480-99f5-48c3-8451-e4b534f47b00)

- 로그인에 성공하면 메인페이지로 들어오게 됩니다. 이곳에서는 사용자가 적립한 총 마일리지, 마일리지를 적립한 날짜를 기록해 주는 달력, 어떤 종류의 화장품을 분리 배출했는지 알려주는 도넛 차트가 있습니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/a7d12fe3-e412-4489-b393-34b6a2416171)

- Eco 앱에 등록된 사람의 마일리지 랭킹을 알 수 있는 페이지 입니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/e664c27d-7797-46a6-b3f3-deff96218c86)


- 마이 페이지에서는 현재 등급을 확인하고 마일리지 현황을 쉽게 파악할 수 있습니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/3215db65-5bd6-48b2-95dd-1547fa7486f3)


- 웹엑스 알림 시스템은 사용자가 화장품 용기의 분리배출을 완료하면 즉각적으로 사용자의 Webex 앱으로 메시지를 전송하는 서비스입니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/ef895a63-3a99-4283-9f3f-6fed4b4c24de)

<br>

## 🚀 시연 영상



<br>

## 📈 향후 발전 가능성 및 기대 효과
- 본 프로젝트는 Webex 네트워크를 활용하여 개발되어 있으므로 Webex를 활용하는 Cisco IoT 시스템 제품군으로 활용할 수 있다.

- 화장품 용기에 국한하지 않고 다양한 재활용품의 분리 수거에도 활용 가능하다.

- 마일리지 정책을 통해 환경 보호와 분리 수거에 대한 관심을 자연스럽게 유도하는데 도움이 된다.

- 화장품 용기를 제조하는 회사가 용기에 모양으로 글자를 새긴다면 본 기술을 통해 보다 쉽게 화장품 용기의 분리 배출이 가능하게 된다.

- 향후 본 프로젝트의 AI 키오스크에 의해 분류된 화장품 용기를 저장하는 기계 장치를 개발하면 완벽한 제품이 될 것으로 기대한다.

- 본 프로젝트에서 만든 IoT 시스템은 다른 유사함 시스템에 곧바로 적용할 수 있다.

- Webex 알림 부분은 향후 Webex의 Webhooks API를 사용하여 안드로이드 Eco 앱으로 직접 알림을 받는 구조를 완성할 계획이다. Webex의 기술 외에도 Cisco의 네트워킹 기술을 다양하게 접목하여 활용하고 IoT 시스템을 더욱 더 확장가능하고 안정적으로 개선하고자 한다.


## 📜 라이선스
MIT licence
