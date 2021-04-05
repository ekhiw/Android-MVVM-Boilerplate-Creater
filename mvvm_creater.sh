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
	echo "1. May use Volley instead of Retrofit."
	echo
	echo "2. Create different packages for different features in the main package. (recommended)"
	echo "OR, Create a package as feature in ui, and then different features in it."
	echo
	echo "3. Keep the version number of the dependencies in a variable and use that variable."
	echo "	example:"
	echo "		def some_version = '1.1.1'"
	echo "		implementation \"com.some.dependencies:depend:\$some_version\""
	echo
	echo "4. Look for the dependencies from here: https://developer.android.com/jetpack/androidx/explorer"
}

#########################################################
# DEPENDENCIES						#
#########################################################
dependencies(){
	echo "_________________________________________________________________________"
	echo "| DEPENDENCIES                                                          |"
	echo "|_______________________________________________________________________|"
	echo
	echo "put -> id 'kotlin-kapt' in the plugins {...} of app's build.gradle"
	echo "then the following dependencies into dependencies {...}"
	echo
	echo "1. Retrofit2"
	echo "	implementation \"com.squareup.retrofit2:retrofit:2.9.0\""
	echo "	implementation \"com.squareup.retrofit2:converter-gson:2.9.0\""
	echo "	implementation \"com.squareup.retrofit2:converter-scalars:2.9.0\""
	echo
	echo "2. Lifecycle"
	echo "	implementation \"androidx.lifecycle:lifecycle-extensions:2.2.0\""
	echo "	implementation \"androidx.lifecycle:lifecycle-viewmodel-savedstate:2.2.0\""
	echo
	echo "3. Dagger2"
	echo "	implementation \"com.google.dagger:dagger:2.28.3\""
	echo "	kapt \"com.google.dagger:dagger-compiler:2.28.3\""
	echo "	implementation \"com.google.dagger:dagger-android:2.28.3\""
    echo "	implementation \"com.google.dagger:dagger-android-support:2.28.3\""
    echo "	kapt \"com.google.dagger:dagger-android-processor:2.28.3\""
}

#########################################################
# OPTIONS CONDITIONS					#
#########################################################
if [[ "$1" == "-h" ]]
	then
		help
		exit 0
fi

if [[ "$1" == "-s" ]]
	then
		suggestions
		exit 0
fi

if [[ "$1" == "-d" ]]
	then
		dependencies
		exit 0
fi

if [[ -z "$1" ]]
	then
		printf "Missing directory path!\nFiles can't be created!\nEXITING..."
		exit 1
fi

if [[ -z "$2" ]]
	then
		printf "Missing base application name!\nRun again with name like:\nWeather,\nToDo,\nGrocery\nEXITING..."
		exit 1
fi

if [[ -z "$3" ]]
	then
		printf "Missing package name!\nRun again!\nEXITING..."
		exit 1
fi


#########################################################
# FILES CREATION					#
#########################################################
echo "Creating MVVM Files in " $1

cd $1

mkdir data
cd data/
mkdir api
cd api/
cat << EOF >> ChuckApi.kt
package $3.data.api

import $3.data.model.ChuckResponse
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
package $3.data

import $3.data.model.AppCustomPreset

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
package $3.data

import $3.data.model.UserToken

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
package $3.data

import $3.data.model.AppCustomPreset
import $3.data.model.UserToken
import $3.data.worker.AppCustomPresetWorker

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
package $3.data.model

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
package $3.data.model

data class ChuckResponse(
    val icon_url: String,
    val id: String,
    val url: String,
    val value: String,
)
EOF
cat << EOF >> UserToken.kt
package $3.data.model

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
package $3.data.repository

import $3.data.model.ChuckResponse
import $3.utils.Resource

interface MainRepository {

    suspend fun getChuck(): Resource<ChuckResponse>

    suspend fun testDatabase()

    suspend fun testRead()
}
EOF
cat << EOF >> DefaultMainRepository.kt
package $3.data.repository

import $3.data.AppCustomDao
import $3.data.TokenDao
import $3.api.ChuckApi
import $3.ChuckResponse
import $3.data.model.UserToken
import $3.utils.Resource

import com.orhanobut.logger.Logger
import kotlinx.coroutines.flow.collect
import javax.inject.Inject

class DefaultMainRepository @Inject constructor(
    private val api: ChuckApi,
    private val tokenDao: TokenDao,
    private val appCustomDao: AppCustomDao
) : MainRepository {

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
            Logger.i("response ${it.time}")
        }
    }


}
EOF
mkdir worker
cd worker/
cat << EOF >> AppCustomPresetWorker.kt
package $3.data.worker

import $3.data.AppDatabase
import $3.data.model.AppCustomPreset

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

echo
echo "----------DONE!----------"

dependencies

suggestions
