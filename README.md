#### Hey there!

![Android MVVM Boilerplate Creater Logo](https://github.com/thenishchalraj/Android-MVVM-Boilerplate-Creater/blob/main/assets/logo_thumb.png)
# Android MVVM Boilerplate Creater
A script that creates the files and codes in them for android MVVM architecture in kotlin.

<img src="https://img.shields.io/badge/Version-v1.3.1-green" /> <img src="https://img.shields.io/badge/License-MIT-blue" />

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
* (for demo) `./mvvm_creater.sh ~/directory ChuckNorris com.example.chucknorris`

Boom! you're done.

#### Packages and files that are created
```
.
└── data/
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
