package com.example.ecosmeticfinal;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.fragment.app.FragmentActivity;
import androidx.viewpager2.adapter.FragmentStateAdapter;
import androidx.viewpager2.widget.ViewPager2;

import me.relex.circleindicator.CircleIndicator3;

public class MainActivity extends FragmentActivity {

    //뷰페이저 관련
    private ViewPager2 mPager;
    private FragmentStateAdapter pagerAdapter;
    private int num_page = 3;       //페이지(fragment) 개수
    private CircleIndicator3 mIndicator; //circle인디케이터
    private int startView = 0;      //뷰 시작시점
    private int maxView = 600;      //최대 뷰 개수

    //하단바 bottomNavigationView관련
    // LinearLayout home_ly;
    //BottomNavigationView bottomNavigationView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //뷰페
        // 이저 관련
        //ViewPager2
        mPager = (ViewPager2) findViewById(R.id.viewpager);
        //1. Adapter
        pagerAdapter = new MyAdapter(this, num_page, maxView);
        mPager.setAdapter(pagerAdapter);
        //2. Indicator
        mIndicator = (CircleIndicator3) findViewById(R.id.indicator);
        mIndicator.setViewPager(mPager);
        mIndicator.createIndicators(num_page, 0); //인디케이터로 표시할 아이콘 개수 지정(=fragment개수와 같게 지정)
        //3. ViewPager Setting
        mPager.setOrientation(ViewPager2.ORIENTATION_HORIZONTAL);
        mPager.setCurrentItem(startView, false);        //시작페이지 설정
        mPager.setOffscreenPageLimit(3);    //페이지의 앞뒤에 몇개의 페이지를 미리 로딩할것인가

        mPager.registerOnPageChangeCallback(new ViewPager2.OnPageChangeCallback() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                super.onPageScrolled(position, positionOffset, positionOffsetPixels);
                if (positionOffsetPixels == 0) {
                    mPager.setCurrentItem(position);
                }
            }

            @Override
            public void onPageSelected(int position) {
                super.onPageSelected(position);
                mIndicator.animatePageSelected(position % num_page);
            }
        }); // end of callback ...

    }// end of onCreate ...

    //로그인 버튼의 이벤트리스너
    public void onClickLogInBtn(View v) {
        Intent LogInIntent = new Intent(this, LogInView.class); //(메시지 보내는 컴포넌트,호출될 컴포넌트)
        startActivity(LogInIntent); //버튼이 눌리면 액티비티 화면 전환
    }

    //회원가입 버튼의 이벤트리스너
    public void onClickJoinBtn(View v) {
        Intent JoinIntent = new Intent(this, JoinView.class); //(메시지 보내는 컴포넌트,호출될 컴포넌트)
        startActivity(JoinIntent); //버튼이 눌리면 액티비티 화면 전환
    }
} // end of MainActivity ...