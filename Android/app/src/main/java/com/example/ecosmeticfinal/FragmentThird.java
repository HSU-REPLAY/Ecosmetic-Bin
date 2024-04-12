package com.example.ecosmeticfinal;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class FragmentThird extends Fragment {
    private int frag_num; // frag_num 변수 선언

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ViewGroup rootView = (ViewGroup) inflater.inflate(
                R.layout.fragment3, container, false);
        return rootView;
    }
    public static FragmentThird newInstance(int num){
        FragmentThird fragment = new FragmentThird();
        Bundle args = new Bundle();
        args.putInt("num",num);
        fragment.setArguments(args);
        return fragment;
    }
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        frag_num = getArguments().getInt("num",0);
    }
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstancdState){
        super.onViewCreated(view,savedInstancdState);
    }
    @Override
    public void onStop() {
        super.onStop();
    }
}
