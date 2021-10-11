#!/bin/bash
# Created by thenishchalraj

#########################################################
# HELP							#
#########################################################
help(){
	echo "_________________________________________________________________________"
	echo "| USAGE OPTIONS                                                         |"
	echo "|_______________________________________________________________________|"
	echo
	echo "-h			show help options"
	echo "-s			show suggestions"
	echo "-d			show dependencies"
	echo "argument1		directory path where files should be created,"
	echo "argument2		base application name,"
	echo "argument3		package name"
	echo
	echo
	echo "Usage example:"
	echo "./mvvm_creater.sh -h"
	echo "---> displays (this) usage"
	echo
	echo "./mvvm_creater.sh ~/test ToDo com.example.todoapp"
	echo "---> create the files for package 'com.example.todoapp' i.e <argument3> with base application name 'ToDo' i.e. <argument2> in directory '~/test' i.e. <argument1>"
}

#########################################################
# SUGGESTIONS						#
#########################################################
suggestions(){
	echo "_________________________________________________________________________"
	echo "| SUGGESTIONS                                                           |"
	echo "|_______________________________________________________________________|"
	echo
}

#########################################################
# DEPENDENCIES						#
#########################################################
dependencies(){

	echo "_________________________________________________________________________"
	echo "| ADD dependencies.gradle                                               |"
	echo "|_______________________________________________________________________|"

}

#########################################################
# OPTIONS CONDITIONS					#
#########################################################
# if [[ "$1" == "-h" ]]
# 	then
# 		help
# 		exit 0
# fi

# if [[ "$1" == "-s" ]]
# 	then
# 		suggestions
# 		exit 0
# fi

# if [[ "$1" == "-d" ]]
# 	then
# 		dependencies
# 		exit 0
# fi

# if [[ -z "$1" ]]
# 	then
# 		printf "Missing directory path!\nFiles can't be created!\nEXITING..."
# 		exit 1
# fi

# if [[ -z "$2" ]]
# 	then
# 		printf "Missing base application name!\nRun again with name like:\nWeather,\nToDo,\nGrocery\nEXITING..."
# 		exit 1
# fi

# if [[ -z "$3" ]]
# 	then
# 		printf "Missing package name!\nRun again!\nEXITING..."
# 		exit 1
# fi
echo "========================="
echo "| Kotlin MVVM generator |"
echo "========================="
echo "What is your app name?(Without Space)"
read _APP_NAME

str1="$_APP_NAME"
str2="Application.kt"
str3="$str1$str2"

str2a="Application"
str3a="$str1$str2a"

echo "======================="
echo "your app name $_APP_NAME"
echo "======================="
echo "Your package?"
read _APP_PACKAGE
echo "======================="
echo "your app package $_APP_PACKAGE"
echo "======================="
echo "Copy your app MainActivity directory"
read _APP_DIR
echo "======================="
echo "your app dir $_APP_DIR"
echo "======================="
echo "Copy your app Parent directory"
read _APP_DIR_PARENT
echo "======================="
echo "your parent dir $_APP_DIR_PARENT"
echo "======================="

#########################################################
# FILES CREATION					#
#########################################################
echo "Creating dependencies.gradle " $_APP_DIR_PARENT

cp dependencies.gradle $_APP_DIR_PARENT

echo "Creating MVVM Files in " $_APP_DIR

cd $_APP_DIR

mkdir data
cd data/
mkdir api
cd api/
cat << EOF >> ChuckApi.kt
package $_APP_PACKAGE.data.api

import $_APP_PACKAGE.data.model.ChuckResponse
import retrofit2.Response
import retrofit2.http.GET

interface ChuckApi {
	
    @GET("/jokes/random")
    suspend fun getChuck(
    ): Response<ChuckResponse>

}
EOF
cd ../
cat << EOF >> AppCustomDao.kt
package $_APP_PACKAGE.data

import $_APP_PACKAGE.data.model.AppCustomPreset

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

/**
 * The Data Access Object for the AppCustomPreset class.
 */
@Dao
interface AppCustomDao {

    @Query("SELECT * FROM custom_preset ORDER BY preset_name")
    fun getAppCustomPresets(): Flow<List<AppCustomPreset>>

    @Query("SELECT * FROM custom_preset WHERE id = :id")
    fun getAppCustomPresetById(id: String): Flow<AppCustomPreset>

    @Query("SELECT * FROM custom_preset WHERE preset_name = :presetName")
    fun getAppCustomPresetByName(presetName: String): Flow<AppCustomPreset>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(plants: List<AppCustomPreset>)
}
EOF
cat << EOF >> TokenDao.kt
package $_APP_PACKAGE.data

import $_APP_PACKAGE.data.model.UserToken

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

/**
 * The Data Access Object for the Token class.
 */
@Dao
interface TokenDao {

    @Query("SELECT * FROM token WHERE id = :id")
    fun getToken(id: String): Flow<UserToken>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(userToken: UserToken)
}
EOF
cat << EOF >> AppDatabase.kt
package $_APP_PACKAGE.data

import $_APP_PACKAGE.data.model.AppCustomPreset
import $_APP_PACKAGE.data.model.UserToken
import $_APP_PACKAGE.data.worker.AppCustomPresetWorker

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.sqlite.db.SupportSQLiteDatabase
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

/**
 * The Room database for this app
 */
@Database(entities = [ UserToken::class, AppCustomPreset::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun tokenDao(): TokenDao
    abstract fun appCustomDao() : AppCustomDao

    companion object {

        // For Singleton instantiation
        @Volatile private var instance: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            return instance ?: synchronized(this) {
                instance ?: buildDatabase(context).also { instance = it }
            }
        }

        // Create and pre-populate the database. See this article for more details:
        // https://medium.com/google-developers/7-pro-tips-for-room-fbadea4bfbd1#4785
        private fun buildDatabase(context: Context): AppDatabase {

            val DATABASE_NAME = "app-db"
            return Room.databaseBuilder(context, AppDatabase::class.java, DATABASE_NAME)
                .addCallback(
                    object : RoomDatabase.Callback() {
                        override fun onCreate(db: SupportSQLiteDatabase) {
                            super.onCreate(db)
                            val request = OneTimeWorkRequestBuilder<AppCustomPresetWorker>().build()
                            WorkManager.getInstance(context).enqueue(request)
                        }
                    }
                )
                .build()
        }
    }
}
EOF
mkdir model
cd model/
cat << EOF >> AppCustomPreset.kt
package $_APP_PACKAGE.data.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "custom_preset")
data class AppCustomPreset(
    @PrimaryKey @ColumnInfo(name = "id")  val id: String,
    val preset_name : String,
    val title : String,
    val logo_big : String,
    val logo_thumbnail : String,
    val primary_color : String,
    val secondary_color : String,
    val accent_color : String,
)
EOF
cat << EOF >> ChuckResponse.kt
package $_APP_PACKAGE.data.model

data class ChuckResponse(
    val icon_url: String,
    val id: String,
    val url: String,
    val value: String,
)
EOF
cat << EOF >> UserToken.kt
package $_APP_PACKAGE.data.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "token")
data class UserToken(
    @PrimaryKey @ColumnInfo(name = "id")  val id: String,
    val jwt: String,
    val time: String,
)
EOF
cd ../
mkdir repository
cd repository/
cat << EOF >> MainRepository.kt
package $_APP_PACKAGE.data.repository

import $_APP_PACKAGE.data.model.ChuckResponse
import $_APP_PACKAGE.utils.Resource

interface MainRepository {

    suspend fun getChuck(): Resource<ChuckResponse>

    suspend fun testDatabase()

    suspend fun testRead()
}
EOF
cat << EOF >> DefaultMainRepository.kt
package $_APP_PACKAGE.data.repository

import $_APP_PACKAGE.data.AppCustomDao
import $_APP_PACKAGE.data.TokenDao
import $_APP_PACKAGE.data.api.ChuckApi
import $_APP_PACKAGE.data.model.ChuckResponse
import $_APP_PACKAGE.data.model.UserToken
import $_APP_PACKAGE.utils.Resource

import com.orhanobut.logger.Logger
import kotlinx.coroutines.flow.collect
import javax.inject.Inject

class DefaultMainRepository @Inject constructor(
    private val api: ChuckApi,
    private val tokenDao: TokenDao,
    private val appCustomDao: AppCustomDao) : MainRepository {

    override suspend fun getChuck(): Resource<ChuckResponse> {
        return try {
            val response = api.getChuck()
            val result = response.body()
            if(response.isSuccessful && result != null) {
                Resource.Success(result)
            } else {
                Resource.Error(response.message())
            }
        } catch(e: Exception) {
            Resource.Error(e.message ?: "An error occured")
        }
    }

    override suspend fun testDatabase() {
        tokenDao.insertAll(UserToken("1","test","test"))
    }

    override suspend fun testRead(){
        tokenDao.getToken("1").collect {

        }
    }
}
EOF
cd ../
mkdir worker
cd worker/
cat << EOF >> AppCustomPresetWorker.kt
package $_APP_PACKAGE.data.worker

import $_APP_PACKAGE.data.AppDatabase
import $_APP_PACKAGE.data.model.AppCustomPreset

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.google.gson.stream.JsonReader
import kotlinx.coroutines.coroutineScope

class AppCustomPresetWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {
    override suspend fun doWork(): Result = coroutineScope {
        try {
            applicationContext.assets.open("app_custom.json").use { inputStream ->
                JsonReader(inputStream.reader()).use { jsonReader ->
                    val presetType = object : TypeToken<List<AppCustomPreset>>() {}.type
                    val presetList: List<AppCustomPreset> =
                        Gson().fromJson(jsonReader, presetType)

                    val database = AppDatabase.getInstance(applicationContext)
                    database.appCustomDao().insertAll(presetList)

                    Result.success()
                }
            }
        } catch (ex: Exception) {
            Result.failure()
        }
    }
}
EOF

cd $_APP_DIR
mkdir di
cd di/
cat << EOF >> AppModule.kt
package $_APP_PACKAGE.di

import $_APP_PACKAGE.BuildConfig
import $_APP_PACKAGE.data.AppCustomDao
import $_APP_PACKAGE.data.TokenDao
import $_APP_PACKAGE.data.api.ChuckApi
import $_APP_PACKAGE.data.repository.DefaultMainRepository
import $_APP_PACKAGE.data.repository.MainRepository
import $_APP_PACKAGE.utils.DispatcherProvider

import android.content.Context
import com.chuckerteam.chucker.api.ChuckerCollector
import com.chuckerteam.chucker.api.ChuckerInterceptor
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    private const val TIMEOUT_IN_SECONDS = 15L

    @Provides
    @Singleton
    fun provideOkHttpClient(@ApplicationContext context: Context): OkHttpClient {
        return OkHttpClient.Builder()
            .apply {

                if (BuildConfig.DEBUG_BUILD) {
                    addInterceptor(
                        ChuckerInterceptor.Builder(context)
                            .collector(ChuckerCollector(context))
                            .maxContentLength(250000L)
                            .redactHeaders(emptySet())
                            .alwaysReadResponseBody(true)
                            .build()
                    )
                }
                connectTimeout(TIMEOUT_IN_SECONDS, TimeUnit.SECONDS)
                writeTimeout(TIMEOUT_IN_SECONDS, TimeUnit.SECONDS)
                readTimeout(TIMEOUT_IN_SECONDS, TimeUnit.SECONDS)
            }
            .build()
    }

    @Singleton
    @Provides
    fun provideChuckApi(okHttpClient: OkHttpClient): ChuckApi = Retrofit.Builder()
        .client(okHttpClient)
        .baseUrl(BuildConfig.BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ChuckApi::class.java)

    @Singleton
    @Provides
    fun provideMainRepository(
        api: ChuckApi,
        tokenDao: TokenDao,
        appCustomDao: AppCustomDao
    ): MainRepository = DefaultMainRepository(api,tokenDao, appCustomDao)

    @Singleton
    @Provides
    fun provideDispatchers(): DispatcherProvider = object : DispatcherProvider {
        override val main: CoroutineDispatcher
            get() = Dispatchers.Main
        override val io: CoroutineDispatcher
            get() = Dispatchers.IO
        override val default: CoroutineDispatcher
            get() = Dispatchers.Default
        override val unconfined: CoroutineDispatcher
            get() = Dispatchers.Unconfined
    }
}
EOF
cat << EOF >> DatabaseModule.kt
package $_APP_PACKAGE.di

import $_APP_PACKAGE.data.AppCustomDao
import $_APP_PACKAGE.data.AppDatabase
import $_APP_PACKAGE.data.TokenDao

import android.content.Context
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Singleton
    @Provides
    fun provideAppDatabase(@ApplicationContext context: Context): AppDatabase {
        return AppDatabase.getInstance(context)
    }

    @Provides
    fun provideTokenDao(appDatabase: AppDatabase): TokenDao {
        return appDatabase.tokenDao()
    }

    @Provides
    fun provideAppCustomDao(appDatabase: AppDatabase): AppCustomDao {
        return appDatabase.appCustomDao()
    }
}
EOF
cat << EOF >> MyAppGlideModule.kt
package $_APP_PACKAGE.di

import com.bumptech.glide.annotation.GlideModule
import com.bumptech.glide.module.AppGlideModule

@GlideModule
class MyAppGlideModule : AppGlideModule(){
}
EOF

cd $_APP_DIR
mkdir ui
cd ui/
mkdir view

cd $_APP_DIR
cd ui/
mkdir viewmodel
cd viewmodel/

cat << EOF >> MainViewModel.kt
package $_APP_PACKAGE.ui.viewmodel

import $_APP_PACKAGE.data.repository.MainRepository
import $_APP_PACKAGE.utils.DispatcherProvider
import $_APP_PACKAGE.utils.Resource

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.orhanobut.logger.Logger
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainViewModel @Inject constructor(
    private val repository: MainRepository,
    private val dispatchers: DispatcherProvider
): ViewModel() {

    fun getChuckNorris(){
        viewModelScope.launch(dispatchers.io){
            when(val response = repository.getChuck()){
                is Resource.Error ->{

                }
                is Resource.Success -> {
                    
                }
            }

        }
    }

    fun testDatabase(){
        viewModelScope.launch(dispatchers.io) {
            repository.testDatabase()
        }
    }

    fun testRead() {
        viewModelScope.launch(dispatchers.io){
            repository.testRead()
        }
    }

}
EOF

cd $_APP_DIR
mkdir utils
cd utils/
cat << EOF >> DispatcherProvider.kt
package $_APP_PACKAGE.utils

import kotlinx.coroutines.CoroutineDispatcher

interface DispatcherProvider {
    val main: CoroutineDispatcher
    val io: CoroutineDispatcher
    val default: CoroutineDispatcher
    val unconfined: CoroutineDispatcher
}
EOF
cat << EOF >> Resource.kt
package $_APP_PACKAGE.utils

sealed class Resource<T>(val data: T?, val message: String?) {
    class Success<T>(data: T) : Resource<T>(data, null)
    class Error<T>(message: String) : Resource<T>(null, message)
}
EOF
cat << EOF >> Commons.kt
package $_APP_PACKAGE.utils

object Commons {


}
EOF

cd $_APP_DIR
cat << EOF >> $str3
package $_APP_PACKAGE

import android.app.Application
import com.orhanobut.logger.AndroidLogAdapter
import com.orhanobut.logger.Logger
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class $str3a  : Application(){
    override fun onCreate() {
        super.onCreate()
        Logger.addLogAdapter(AndroidLogAdapter())
        Logger.i("APP OnCreate")
    }
}
EOF
cd $_APP_DIR_PARENT
rm build.gradle
cat << EOF >> build.gradle
// Top-level build file where you can add configuration options common to all sub-projects/modules.

apply from: 'dependencies.gradle'

buildscript {
    apply from: "/dependencies.gradle"
    ext {
        kotlin_version = "1.5.30"
    }
    repositories {
        google()
        jcenter()
        maven { url 'https://dl.bintray.com/kotlin/kotlin-eap' }
    }
    dependencies {
        classpath "com.android.tools.build:gradle:7.0.2"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:kotlin_version"
        classpath "com.google.dagger:hilt-android-gradle-plugin:{deps.v.HILT_ANDROID_VERSION}"
        classpath "androidx.navigation:navigation-safe-args-gradle-plugin:{deps.v.NAVIGATION_VERSION}"


        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        google()
        jcenter()
        maven { url 'https://jitpack.io' }
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF

cd $_APP_DIR_PARENT/app
rm build.gradle
cat << EOF >> build.gradle
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
    id 'androidx.navigation.safeargs.kotlin'
}

def cmd = 'git rev-list HEAD --count'
def gitVersion = cmd.execute().text.trim().toInteger()


android {
    def versionMajor = 1
    def versionMinor = 0
    def versionPatch = 0

    def versionBuild = gitVersion

    compileSdkVersion 30
    buildToolsVersion "30.0.3"

    defaultConfig {
        applicationId "$_APP_PACKAGE"
        minSdkVersion 22
        targetSdkVersion 30

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        buildConfigField "String", "APP_VERSION", "\"{versionMajor}.{versionMinor}.{versionPatch}-{versionBuild}\""
        versionName ""
        versionCode versionMajor * 10000 + versionMinor * 1000 + versionPatch * 100 + versionBuild
    }

    buildFeatures {
        viewBinding true
    }

    buildTypes {

        debug {
            debuggable true
            zipAlignEnabled false
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'

            buildConfigField "String", "BASE_URL", "\"https://api.example.com\""
            buildConfigField "Boolean", "DEBUG_BUILD", "true"

        }
        release {
            debuggable false
            zipAlignEnabled false
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'


            buildConfigField "String", "BASE_URL", "\"https://api.example.com\""
            buildConfigField "Boolean", "DEBUG_BUILD", "false"
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    implementation 'androidx.legacy:legacy-support-v4:1.0.0'
    def deps = rootProject.ext.deps

    //Androidx
    implementation deps.androidx.ACTIVITY_KTX
    implementation deps.androidx.APP_COMPAT
    implementation deps.androidx.CORE_KTX
    implementation deps.androidx.CONSTRAINT_LAYOUT
    implementation deps.androidx.RECYCLER_VIEW

    implementation deps.androidx.LIFECYCLE_VIEWMODEL
    implementation deps.androidx.LIFECYCLE_RUNTIME
    implementation deps.androidx.LIFECYCLE_EXTENSIONS
    implementation deps.androidx.LIFECYCLE_LIVEDATA

    implementation deps.androidx.NAVIGATION_FRAGMENT
    implementation deps.androidx.NAVIGATION_UI


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
    implementation deps.misc.PERMISSION
    implementation deps.misc.THREETEN

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
EOF

echo 
echo "===================DONE!==================="
echo "===== 1. CHANGE YOUR MainActivity.kt ======"
echo "@AndroidEntryPoint"
echo "class MainActivity : AppCompatActivity() {"
echo "    private lateinit var binding: ActivityMainBinding"
echo ""
echo "    override fun onCreate(savedInstanceState: Bundle?) {"
echo "        super.onCreate(savedInstanceState)"
echo "        binding = ActivityMainBinding.inflate(layoutInflater)"
echo "        setContentView(binding.root)"
echo "        supportActionBar?.hide()"
echo "    }"
echo "}"
echo "============================================"
echo "=== 2. CHANGE YOUR app name in Manifest ===="
echo "android:name=\".$str3a\""
echo "============================================"
echo "============= 3. TODO ======================"
echo "TODO : add navigation"
echo "TODO : resolve dependencies"
