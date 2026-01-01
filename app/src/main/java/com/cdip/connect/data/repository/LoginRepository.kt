import android.content.Context
import com.cdip.connect.data.model.LoginResponse
import com.cdip.connect.utils.SharedPreferencesManager
import com.cdip.connect.utils.VersionCheckManager

class LoginRepository(private val context: Context, private val apiService: ApiService) {
    private val preferencesManager = SharedPreferencesManager(context)
    private val versionCheckManager = VersionCheckManager(context)

    suspend fun login(phone: String, password: String): Result<LoginResponse> {
        return try {
            val response = apiService.memberLogin(
                mapOf(
                    "phone" to phone,
                    "password" to password
                )
            )
            
            if (response.status == 200) {
                preferencesManager.saveLoginData(response)
                versionCheckManager.checkAndNotifyVersionUpdate(response.app_version)
                Result.success(response)
            } else {
                Result.failure(Exception(response.message))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    fun logout() {
        preferencesManager.clearLoginData()
    }
}
