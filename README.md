#### Hey there!

![Android MVVM Boilerplate Creater Logo](https://github.com/thenishchalraj/Android-MVVM-Boilerplate-Creater/blob/main/assets/logo_thumb.png)
# Android MVVM Boilerplate Creater
A script that creates the files and codes in them for android MVVM architecture in kotlin.

<img src="https://img.shields.io/badge/Version-ekhiw-green" /> <img src="https://img.shields.io/badge/License-MIT-blue" />

[Android-MVVM-Boilerplate-Creater - behind the scenes](https://proandroiddev.com/android-mvvm-boilerplate-creater-behind-the-scenes-1184e6d26fd3)

### Features
- [x] Type command > Enter > Done. (it's that fast)
- [x] Each layer in different package.
- [x] Generates basic utility package too.
- [x] Packages with all the basic codes in Kotlin.
- [x] Contains imports for all the files created.
- [x] Uses Retrofit2, Dagger2 and Lifecycle.
- [x] Dependencies and suggestions after boilerplate created.

### Steps to run
(tested on mac)

* `git clone https://github.com/ekhiw/Android-MVVM-Boilerplate-Creater.git`
* `cd Android-MVVM-Boilerplate-Creater`
* `copy your app path (/Users/...../app/src/main/java/com/example/chucknorris)
* (for demo) `./mvvm_creater.sh ~/app-directory ChuckNorris com.example.chucknorris`

Boom! you're done.

#### Packages and files that are created
```
.
└── app/
    ├── data/
    │   ├── api/
    |   |   └── ChuckApi.kt
    │   ├── model/
    |   |   ├── AppCustomPreset.kt
    |   |   ├── ChuckResponse.kt
    |   |   └── UserToken.kt
    │   ├── repository/
    |   |   ├── MainRepository.kt
    |   |   └── DefaultMainRepository.kt
    │   ├── worker/
    |   |   └── AppCustomPresetWorker.kt
    │   ├── AppCustomDao.kt
    │   ├── TokenDao.kt
    │   └── AppDatabase.kt
    ├── di/
    |   ├── AppModule.kt
    |   └── DatabaseModule.kt
    ├── ui/
    │   ├── view/
    │   └── viewmodel/
    │       └── MainViewModel.kt
    ├── utils/
    │   ├── Resource.kt
    │   └── DispatcherProvider.kt
    └── ChuckNorrisApplication.kt
```
### Dependencies
App level
```
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}
apply plugin: 'kotlin-android'


android {
    .
    .
    .
    .
    .
    
    buildFeatures {
        viewBinding true
    }
    buildTypes {
        debug {
            .
            .
            .
            .
            .
            
            buildConfigField "String", "BASE_URL", "\"https://api.chucknorris.io/\""
            buildConfigField "Boolean", "DEBUG_BUILD", "true"
        }
    }
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    def deps = rootProject.ext.deps

    //Androidx
    implementation deps.androidx.ACTIVITY_KTX 
    implementation deps.androidx.APP_COMPAT 
    implementation deps.androidx.CORE_KTX 
    implementation deps.androidx.CONSTRAINT_LAYOUT 

    implementation deps.androidx.LIFECYCLE_VIEWMODEL 
    implementation deps.androidx.LIFECYCLE_RUNTIME 
    implementation deps.androidx.LIFECYCLE_EXTENSIONS 
    implementation deps.androidx.LIFECYCLE_LIVEDATA 

    implementation deps.androidx.HILT_LIFECYCLE_VM 
    kapt deps.androidx.HITL_COMPILER 

    implementation deps.dagger.HILT_ANDROID 
    kapt deps.dagger.HILT_ANDROID_COMPILER 

    // Room
    kapt deps.androidx.ROOM_COMPILER
    implementation deps.androidx.ROOM_RUNTIME
    implementation deps.androidx.ROOM_KTX
    implementation deps.androidx.WORK_RUNTIME

    //misc
    implementation deps.misc.MATERIAL_DESIGN 
    implementation deps.misc.ORHANOBUT

    //Kotlin
    implementation deps.kotlinlib.STD_LIB 
    implementation deps.kotlinlib.COROUTINES_CORE 
    implementation deps.kotlinlib.COROUTINES_ANDROID 

    // Retrofit
    implementation deps.square.LOGGING_INTERCEPTOR
    implementation deps.square.OKHTTP 
    implementation deps.square.RETROFIT 
    implementation deps.square.RETROFIT_MOSHI
    implementation deps.square.RETROFIT_GSON 

    // Glide
    kapt deps.glide.GLIDE_COMPILER
    implementation deps.glide.GLIDE

    // Chucker
    debugImplementation deps.chucker.CHUCKER_DEBUG
    releaseImplementation deps.chucker.CHUCKER_NO_OP_RELEASE
}

repositories {
    maven { url 'https://dl.bintray.com/kotlin/kotlin-eap' }
    mavenCentral()
}

```

Project Level
```
// Top-level build file where you can add configuration options common to all sub-projects/modules.

apply from: 'dependencies.gradle'

buildscript {

    ext {
        kotlin_version = "1.4.31"
    }

    repositories {
        google()
        jcenter()
        maven { url 'https://dl.bintray.com/kotlin/kotlin-eap' }
    }
    dependencies {
        classpath "com.android.tools.build:gradle:4.1.3"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath "com.google.dagger:hilt-android-gradle-plugin:2.31.2-alpha"
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```


### Usage
* -h (shows help)
* -s (shows suggestions)
* -d (shows used dependencies)
* arguments 1, 2, 3 (path-to-directory, base application name, application package name)

### References
* [Bash Cheatsheet](https://devhints.io/bash)
* [Shell Scripting](https://tecadmin.net/tutorial/bash-scripting/)
* [Functions in Bash](https://linuxize.com/post/bash-functions/)
* [Exit in Bash](https://askubuntu.com/questions/892604/what-is-the-meaning-of-exit-0-exit-1-and-exit-2-in-a-bash-script)

### License
Read the license [here](https://github.com/thenishchalraj/Android-MVVM-Boilerplate-Creater/blob/main/LICENSE)
