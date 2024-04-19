# 🌏 Ecosmetic-Bin
![soft](https://capsule-render.vercel.app/api?type=soft&color=auto&text=2024%20Cisco%20Innovation%20Challenge%20Hackathon&fontSize=35&animation=twinkling)
<br>

## 🖥️ 프로젝트 소개
- ### 🙋 문제점 제시
   - 오늘날 화장품이 현대 사회의 필수품으로 자리 잡으면서 화장품 소비량이 증가하고 있습니다. 이에 따라 화장품 용기 쓰레기 양도 상대적으로 증가하여 심각한 환경 문제로 떠오르고 있습니다. 
  - 화장품 용기 분리 배출 인식 부족 및 무분별한 배출
     - 화장품 용기에는 플라스틱, 유리, 캔 등 다양한 종류가 있지만 소비자는 이를 인지하지 못한 채 일반 쓰레기로 배출합니다.

  - 화장품 용기 분리 배출 유인책 부재
    - 국가나 지방 자치 단체는 화장품 용기 분리 배출에 적극적으로 참여한 사람들에게 마일리지를 적립시키는 등 유인책을 전혀 제시하지 못하고 있습니다. 

- ### 🚩 개발 목적 
   - 개발 목적 지능형 분리수거함을 포함하여 사용자별 화장품 마일리지를 적립하여 사용자가 스마트폰으로 언제든지 분리 배출 목록과 마일리지를 확인할 수 있는 선순환 구조의 IoT 시스템 입니다.

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
![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/2d260c51-a072-4ba7-9003-b8c836324d86)

<br>

## 💝 주요 기능
- AI 키오스크를 사용해서 MQTT 프로토콜을 통해 로그인 과정을 진행합니다. Eco 웹서버의 데이터베이스에서 사용자의 아이디를 찾은 후 로그인을 진행합니다.

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/09478fc5-7d54-4f23-b2ab-964570e1570d" width="400"/></p>

- 로그인에 성공하고 처음 분류를 시작하는 경우에는, ‘HD Webcam’이 자동으로 선택됩니다. 라즈베리 파이의 USB 포트에 연결된 웹 캠을 통해 촬영된 영상을 AI 키오스크에서 실시간으로 확인할 수 있습니다.

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/f5ee8a2c-8ed7-4da0-9701-401b80e65f69" width="200"/></p>

- MQTT 통신을 이용한 실시간 스트리밍 과정입니다. OpenCV를 사용하여 JPEG으로 만든 후 각 프레임을 base64로 인코딩 합니다. UI 모듈에서 다시 각 프레임을 base64로 디코딩하여 AI 키오스크에 그리는 방식을 통해 구현했습니다. 

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/05072ce6-dcf9-403a-b8ab-6bc4e5492ef4" width="700"/></p>

- 웹캠을 통한 촬영은 OpenCV의 VideoCapture 객체를 사용해 직접 사진을 촬영하고 이를 파일로 저장합니다. 

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/929d4102-85c3-4ded-b581-334aba1aa575" width="700"/></p>


- Cisco의 Meraki camera는 다음과 같은 과정으로 촬영을 진행합니다. 

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/f016ff73-78f1-4880-85fb-992be2e0c4d7" width="700"/></p>

- AI 엔진은 먼저 OCR 라이브러리인 PyTesseract를 사용하여 촬영된 이미지로부터 ‘Plastic’, ‘Glass’, ‘Can’이 적힌 용기들을 분류하고 용기의 개수를 세준 후 결과 메시지를 UI에게 전송해 줍니다.

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/d5bea59b-ac34-45df-8683-cc451f5b1050" width="700"/></p>



<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/4d8282cb-d3c7-429c-9d37-8c4a45b82b5d" width="700"/></p>


- 안드로이드 Eco앱 초기화면

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/8569e1a3-ad12-40ae-b284-2af009e00520" width="200"/></p>

- 왼쪽은 회원가입 화면입니다. 사용자는 Eco 웹 서버 ID와 Webex ID를 입력하여 회원으로 가입합니다. Eco 웹 서버는 수신한 사용자 ID와 Webex ID를 user 테이블과 webex 테이블에 기록합니다. <br>
Webex ID는 추후 사용자가 키오스크에서 분리 배출을 할 때 알림을 받기 위해 사용됩니다.

<p align="center">
  <img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/5a8b3fb1-4924-4202-91af-1734f7a32bb1" style="width: 200px;">
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/b176ce7e-1f9c-4ed0-8259-2ee22132675b" style="width: 200px;">
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/be995139-2170-4b52-b6f3-21456bcfff61" style="width: 200px;">
</p>

- 로그인에 성공하면 메인페이지로 들어오게 됩니다. 이 곳에서는 사용자가 적립한 총 마일리지, 마일리지를 적립한 날짜를 기록해주는 달력, 어떤 종류의 화장품을 분리 배출했는지 알려주는 도넛 차트가 있습니다.

<p align="center"><img src="https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/109191101/984f71d5-21f1-4b25-938e-5873478b8f1f" width="200"/></p>

- Eco 앱에 등록된 사람의 마일리지 랭킹을 알 수 있는 페이지 입니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/e664c27d-7797-46a6-b3f3-deff96218c86)


- 마이 페이지에서는 현재 등급을 확인하고 마일리지 현황을 쉽게 파악할 수 있습니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/3215db65-5bd6-48b2-95dd-1547fa7486f3)


- 웹엑스 알림 시스템은 사용자가 화장품 용기를 분리 배출을 완료하면 즉각적으로 사용자의 Webex 앱으로 메시지를 전송하는 서비스입니다.

![image](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/ef895a63-3a99-4283-9f3f-6fed4b4c24de)

<br>

## 🚀 시연 영상
- 밑의 사진을 클릭하면 youtube 주소로 이동합니다.
[![My YouTube Video Thumbnail](https://github.com/HSU-REPLAY/Ecosmetic-Bin/assets/121416032/ddec290b-4381-4ff5-ae10-004aca85c43c)](https://www.youtube.com/watch?v=CitKeV7mHRE)


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
