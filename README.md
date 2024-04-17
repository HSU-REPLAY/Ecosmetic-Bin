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

## 🔧 시스템 전체 구조
```
Ecosmetic-Bin
├── Android
│   ├── app
│   │   ├── build.gradle.kts
│   │   ├── proguard-rules.pro
│   │   └── src
│   │       ├── androidTest
│   │       │   └── java
│   │       │       └── com
│   │       │           └── example
│   │       │               └── ecosmeticfinal
│   │       │                   └── ExampleInstrumentedTest.java
│   │       ├── main
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── java
│   │       │   │   └── com
│   │       │   │       └── example
│   │       │   │           └── ecosmeticfinal
│   │       │   │               ├── FragmentFirst.java
│   │       │   │               ├── FragmentSecond.java
│   │       │   │               ├── FragmentThird.java
│   │       │   │               ├── JoinView.java
│   │       │   │               ├── LogInView.java
│   │       │   │               ├── MainActivity.java
│   │       │   │               └── MyAdapter.java
│   │       │   └── res
│   │       │       ├── drawable
│   │       │       │   ├── buttonshapefull.xml
│   │       │       │   ├── buttonshapeline.xml
│   │       │       │   ├── cosmetic.png
│   │       │       │   ├── default_dot.xml
│   │       │       │   ├── diary.png
│   │       │       │   ├── graph.png
│   │       │       │   ├── ic_launcher_background.xml
│   │       │       │   ├── ic_launcher_foreground.xml
│   │       │       │   ├── money.png
│   │       │       │   ├── my_menu_back.png
│   │       │       │   └── selected_dot.xml
│   │       │       ├── layout
│   │       │       │   ├── activity_join_view.xml
│   │       │       │   ├── activity_log_in_view.xml
│   │       │       │   ├── activity_main.xml
│   │       │       │   ├── custom_actionbar_join.xml
│   │       │       │   ├── custom_actionbar_login.xml
│   │       │       │   ├── fragment1.xml
│   │       │       │   ├── fragment2.xml
│   │       │       │   └── fragment3.xml
│   │       │       ├── menu
│   │       │       │   └── menu.xml
│   │       │       ├── mipmap-anydpi-v26
│   │       │       │   ├── ic_launcher.xml
│   │       │       │   └── ic_launcher_round.xml
│   │       │       ├── mipmap-hdpi
│   │       │       │   ├── ic_launcher.webp
│   │       │       │   └── ic_launcher_round.webp
│   │       │       ├── mipmap-mdpi
│   │       │       │   ├── ic_launcher.webp
│   │       │       │   └── ic_launcher_round.webp
│   │       │       ├── mipmap-xhdpi
│   │       │       │   ├── ic_launcher.webp
│   │       │       │   └── ic_launcher_round.webp
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   ├── ic_launcher.webp
│   │       │       │   └── ic_launcher_round.webp
│   │       │       ├── mipmap-xxxhdpi
│   │       │       │   ├── ic_launcher.webp
│   │       │       │   └── ic_launcher_round.webp
│   │       │       ├── values
│   │       │       │   ├── colors.xml
│   │       │       │   ├── dimens.xml
│   │       │       │   ├── strings.xml
│   │       │       │   └── themes.xml
│   │       │       ├── values-night
│   │       │       │   └── themes.xml
│   │       │       └── xml
│   │       │           ├── backup_rules.xml
│   │       │           └── data_extraction_rules.xml
│   │       └── test
│   │           └── java
│   │               └── com
│   │                   └── example
│   │                       └── ecosmeticfinal
│   │                           └── ExampleUnitTest.java
│   ├── build.gradle.kts
│   ├── dfs.txt
│   ├── gradle
│   │   ├── libs.versions.toml
│   │   └── wrapper
│   │       ├── gradle-wrapper.jar
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   └── settings.gradle.kts
├── LICENSE
├── README.md
├── requirements.txt
├── server
│   ├── build
│   │   └── classes
│   │       └── ecobin
│   │           ├── Servlet.class
│   │           └── WebexMessageSender.class
│   └── src
│       └── main
│           ├── java
│           │   └── ecobin
│           │       ├── Servlet.java
│           │       └── WebexMessageSender.java
│           └── webapp
│               ├── Bronze.png
│               ├── Diamond.png
│               ├── Gold.png
│               ├── META-INF
│               │   └── MANIFEST.MF
│               ├── Platinum.png
│               ├── Silver.png
│               ├── WEB-INF
│               │   ├── lib
│               │   │   ├── jackson-annotations-2.11.0.jar
│               │   │   ├── jackson-core-2.11.0.jar
│               │   │   ├── jackson-databind-2.11.0.jar
│               │   │   ├── json-20240303.jar
│               │   │   ├── json-simple-1.1.1.jar
│               │   │   └── mysql-connector-j-8.3.0.jar
│               │   └── web.xml
│               ├── bronze-medal.png
│               ├── can.png
│               ├── ecomesticBin.jsp
│               ├── glass.png
│               ├── gold-medal.png
│               ├── home.jsp
│               ├── home.png
│               ├── homecheck.png
│               ├── left.png
│               ├── logo.png
│               ├── mileage-coin.png
│               ├── mileageChart.jsp
│               ├── my.png
│               ├── myPage.jsp
│               ├── mycheck.png
│               ├── next.png
│               ├── plastic.png
│               ├── pre.png
│               ├── range.png
│               ├── rank.png
│               ├── rankcheck.png
│               ├── ranking.jsp
│               ├── signUp.jsp
│               ├── silver-medal.png
│               ├── type.png
│               ├── updateChartData.jsp
│               └── user.png
├── setup.sh
└── source
    ├── analysisScreen.css
    ├── button.css
    ├── camera.py
    ├── cameraIcon.svg
    ├── checked.png
    ├── cleanTrashbin.css
    ├── ecosmeticLogo.png
    ├── homeScreen.css
    ├── image.jpg
    ├── index.html
    ├── keyboard.css
    ├── keyboard.js
    ├── loading.gif
    ├── loadingScreen.css
    ├── main.js
    ├── mainScreen.css
    ├── merakicam.py
    ├── mileage-coin.png
    ├── mileageResultScreen.css
    ├── mqtt.py
    ├── mqttio.js
    ├── new_mqtthandler.py
    ├── ocr.py
    ├── package-lock.json
    ├── package.json
    ├── resultScreen.css
    ├── streaming.js
    └── style.css

```

## 💝 주요 기능


## 🚀 시연 영상


## 📜 라이선스
MIT licence
