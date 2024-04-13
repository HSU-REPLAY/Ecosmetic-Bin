package com.example.ecosmeticfinal;

import android.os.Bundle;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

public class JoinView extends AppCompatActivity {

    private ActionBar actionBar;
    //private TextView titleTextView; //액션바의 타이틀
    private WebView webView;
    private String url="https:/www.daum.net"; //여기에 이동하고 싶은 웹 주소 입력

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join_view);

        //액션바 관련
        actionBar=getSupportActionBar();
        if (actionBar == null) { //액션바가 null이면
            // ActionBar가 null이면 사용자에게 메시지를 표시합니다.
            Toast.makeText(this, "ActionBar를 찾을 수 없습니다.", Toast.LENGTH_SHORT).show();
            return;
        }
        else {
            //actionBar.setTitle(getString(R.string.join_action_bar_title)); //실행 중 액션바 타이틀을 변경
            actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM); //커스텀 된 액션바로 설정
            actionBar.setCustomView(R.layout.custom_actionbar_join); // res/layout/custom_action_bar에 작성한 설정 적용
            ActionBar.LayoutParams params = new ActionBar.LayoutParams(ActionBar.LayoutParams.WRAP_CONTENT, ActionBar.LayoutParams.WRAP_CONTENT, Gravity.CENTER);
            actionBar.setCustomView(actionBar.getCustomView(), params);
            //액션바 홈버튼 관련
            actionBar.setDisplayHomeAsUpEnabled(true); //툴바의 홈버튼을 활성화(아이콘을 맨 왼쪽으로 배치하는 방법의 대안)
            getSupportActionBar().setHomeAsUpIndicator(R.drawable.my_menu_back);//홈버튼 이미지를 뒤로가기 이미지로 변경
            //액션바 타이틀 변경
            //titleTextView = findViewById(R.id.action_bar_title); //layout/custom_action_bar.xml에 정의
            // titleTextView.setText(getString(R.string.join_action_bar_title)); //values/string.xml에 정의
        }
        //웹뷰 변수 설정
        webView=(WebView)findViewById(R.id.joinWebViewId);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadUrl(url);
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(new WebViewClientClass());
        //net::ERR_CACHE_MISS에 대한 해결 방법
        webView.getSettings().setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
    }
    /*//액티비티가 활성화 될 때마다 호출
    @Override
    public void onResume(){
        super.onResume();
        actionBar.setTitle(getString(R.string.join_action_bar_title));
    }*/
    //res/menu/menu.xml파일에 설정한 메뉴바 붙이기
    @Override
    public boolean onCreateOptionsMenu(Menu menu)    {
        super.onCreateOptionsMenu(menu);
        getMenuInflater().inflate(R.menu.menu, menu);
        return true;
    }
    //메뉴바 뒤로가기 메뉴를 눌렀을 때의 동작 설정
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (/*item.getItemId() == R.id.back_action||*/item.getItemId()==android.R.id.home) { //뒤로가기 아이콘 또는 홈버튼(뒤로가기 이미지로 둔갑) 누르면
            onBackPressed(); // 뒤로가기 동작 실행
            return true;
        }
        else {
            return super.onOptionsItemSelected(item); // 기본 동작 수행
        }
    }
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if((keyCode==KeyEvent.KEYCODE_BACK)&&webView.canGoBack()){ //키 이벤트 처리
            webView.goBack(); //뒤로 가기
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
    private class WebViewClientClass extends WebViewClient {
        //현재 페이지의 url을 읽어올 수 있는 메서드
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            view.loadUrl(url);
            return true;
        }
    }
}