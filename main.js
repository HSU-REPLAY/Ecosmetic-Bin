'use strict';

const electron = require('electron'); // 일렉트론 모듈 읽기
const app = electron.app; // 일렉트론 객체에 대힌 참조 저장
const BrowserWindow = electron.BrowserWindow; // 

let mainWindow = null; // 저장할 변수 

// 화면을 종료하면 애플리케이션 종료
app.on('window-all-closed', () => {
    if(process.platform !== 'darwin') app.quit();
});

app.on('ready', () => {
    // 전체 화면: {fullscreen: true}
    // 로드되면 mainWindow 변수에 BrowserWindow 할당
    mainWindow = new BrowserWindow({fullscreen: true});   // 꽉 찬 화면 설정
    mainWindow.loadURL(`file://${__dirname}/index.html`); // index.html 읽기
    mainWindow.on('closed', () => {mainWindow = null;}); // 애플리케이션 화면을 닫으면 변수를 null로 지정
});