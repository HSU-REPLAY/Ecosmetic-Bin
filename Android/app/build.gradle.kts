plugins {
    alias(libs.plugins.androidApplication)
}

android {
    namespace = "com.example.ecosmeticfinal"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.ecosmeticfinal"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

dependencies {

    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)

    //viewpager
    implementation("com.google.android.material:material:1.3.0-alpha03")
    implementation("androidx.viewpager2:viewpager2:1.0.0") // Viewpager2 라이브러리 추가
    implementation("me.relex:circleindicator:2.1.6") // Viewpager Indicator Circle 라이브러리 추가
}