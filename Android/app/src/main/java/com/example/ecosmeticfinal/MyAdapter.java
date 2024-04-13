package com.example.ecosmeticfinal;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.viewpager2.adapter.FragmentStateAdapter;

public class MyAdapter extends FragmentStateAdapter {
    public int mCount;
    public int MAX;
    public MyAdapter(FragmentActivity fa, int count, int max) {
        super(fa);
        mCount = count;
        MAX = max;
    }
    @NonNull
    @Override
    public Fragment createFragment(int position) {
        int index = getRealPosition(position);
        switch(index){
            case 0 :
                return FragmentFirst.newInstance(position+1);
            case 1:
                return FragmentSecond.newInstance(position+1);
            case 2:
                return FragmentThird.newInstance(position+1);
            default:
                return null;
        }
    }
    @Override
    public int getItemCount() {
        return MAX;
    }
    public int getRealPosition(int position) { return position % mCount; }
}