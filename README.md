# Android Kotlin MVVM boilerplate
Forked from thenishchalraj, I modify this shell command to suit my needs. Kotlin MVVM hilt room retrovit.

## Tech
- Kotlin MVVM
- Dagger hilt
- Retrofit
- Room database
- Glide

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
    |   ├── MyAppGlideModule.kt
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

### 1. Create Project.
![Create Project](https://github.com/ekhiw/Android-MVVM-Boilerplate-Creater/blob/main/assets/sc1a.png)

### 2. Clone this repo and open terminal in repo folder.
![Create Project](https://github.com/ekhiw/Android-MVVM-Boilerplate-Creater/blob/main/assets/sc1.png)

### 3. Run shell command and fill required data.
![Create Project](https://github.com/ekhiw/Android-MVVM-Boilerplate-Creater/blob/main/assets/sc2.png)
