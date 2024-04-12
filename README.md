# Ecosmetic-Bin

초기 모듈 설치 방법

1. git clone <레포지트리 주소>

2. Ecosmetic-Bin 파일로 이동

3. 가상환경 설정

   ```bash
   python3 -m venv myenv
   ```

4. 가상환경으로 전환

   ```bash
   source myenv/bin/activate
   ```

5. 파이썬 모듈 전체 설치

   ```bash
   pip install -r requirements.txt
   ```

6. Node.js, Electron 설치

   ```bash
   bash setup.sh
   ```

실행 방법

1. 터미널1 (mqtt broker)

   ```bash
   mosquitto -v -c mos.conf
   ```

   already in use 오류시 sudo systemctl stop mosquitto

2. 터미널2 (mqtt publisher)

   ```bash
   source myenv/bin/activate
   python mqtt.py
   ```

3. 터미널3 (통신 모듈)

   ```
   source myenv/bin/activate
   python mqtt_handler.py
   ```

4. vnc 환경에서 터미널4 (electron)

   ```l
   source myenv/bin/activate
   electron .
   ```

5. 추가 설정

   ```
   - 이클립스 DataServlet 클래스 파일 추가 후 톰캣 실행(Run on Server)
   - mqtt_handler.py-> url 수정(자신의 노트북 ip, 프로젝트 파일 이름 변경)
   ```

   🔥🔥

   
