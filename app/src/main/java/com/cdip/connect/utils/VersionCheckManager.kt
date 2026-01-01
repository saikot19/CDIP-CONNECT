import android.content.Context
import android.widget.Toast
import android.content.pm.PackageManager

class VersionCheckManager(private val context: Context) {

    fun checkAndNotifyVersionUpdate(serverVersion: String) {
        val currentVersion = getCurrentAppVersion()
        
        if (isVersionOutdated(currentVersion, serverVersion)) {
            showUpdateToast()
        }
    }

    private fun getCurrentAppVersion(): String {
        return try {
            context.packageManager.getPackageInfo(context.packageName, 0).versionName
        } catch (e: PackageManager.NameNotFoundException) {
            "0.0.0"
        }
    }

    private fun isVersionOutdated(currentVersion: String, serverVersion: String): Boolean {
        val current = currentVersion.split(".").map { it.toIntOrNull() ?: 0 }
        val server = serverVersion.split(".").map { it.toIntOrNull() ?: 0 }
        
        for (i in 0 until maxOf(current.size, server.size)) {
            val curr = current.getOrNull(i) ?: 0
            val serv = server.getOrNull(i) ?: 0
            if (serv > curr) return true
            if (curr > serv) return false
        }
        return false
    }

    private fun showUpdateToast() {
        Toast.makeText(
            context,
            "A new version is available. Please update your app.",
            Toast.LENGTH_LONG
        ).show()
    }
}
