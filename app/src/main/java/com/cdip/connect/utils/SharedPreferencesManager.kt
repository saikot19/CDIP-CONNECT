import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.cdip.connect.data.model.LoginResponse
import com.cdip.connect.data.model.UserData

class SharedPreferencesManager(context: Context) {
    private val sharedPreferences: SharedPreferences = 
        context.getSharedPreferences("cdip_connect_prefs", Context.MODE_PRIVATE)
    private val gson = Gson()

    fun saveLoginData(loginResponse: LoginResponse) {
        sharedPreferences.edit().apply {
            putString("app_version", loginResponse.app_version)
            putString("access_token", loginResponse.access_token)
            putString("last_updated", loginResponse.last_updated)
            putString("user_data", gson.toJson(loginResponse.user_data))
            apply()
        }
    }

    fun getAppVersion(): String? = sharedPreferences.getString("app_version", null)

    fun getAccessToken(): String? = sharedPreferences.getString("access_token", null)

    fun getLastUpdated(): String? = sharedPreferences.getString("last_updated", null)

    fun getUserData(): UserData? {
        val userDataJson = sharedPreferences.getString("user_data", null)
        return if (userDataJson != null) {
            gson.fromJson(userDataJson, UserData::class.java)
        } else null
    }

    fun clearLoginData() {
        sharedPreferences.edit().apply {
            remove("app_version")
            remove("access_token")
            remove("last_updated")
            remove("user_data")
            apply()
        }
    }

    fun isLoggedIn(): Boolean = getAccessToken() != null
}
