package deadsmond.net.flatmapp

import android.R
import android.app.IntentService
import android.app.Service
import android.content.Context
import android.content.Intent
import android.location.Location
import android.media.AudioManager
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.Settings.Global
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import io.flutter.Log
import java.io.File


class FlatMappService : IntentService("FlatMapp Service"){

    val TAG = "FlatMapp Service"
    val DEFAULT_NOTIFICATION_SOUND: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var markerPath:String
    private var isRunning:Boolean = true

    override fun onCreate(){
        showLog("onCreate")
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        markerPath = baseContext.filesDir.path + "/../app_flutter"
    }


    override fun onDestroy() {
        showLog("onDestroy")
        isRunning = false
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        showLog("onStartCommand")
        var builder:NotificationCompat.Builder = NotificationCompat.Builder(this, "FlatMappMesseges")
                .setContentText("FlatMapp Service")
                .setContentTitle("FlutMapp service is running in the background")
                .setSmallIcon(R.drawable.ic_popup_reminder)
                .setPriority(NotificationCompat.PRIORITY_LOW)

        startForeground(101, builder.build())
        //popUpNotification("Notification Title", "Notification Description")
        var markerFile = File(markerPath + "/marker_storage.json")
        showLog(markerFile.readText())

        return super.onStartCommand(intent, flags, startId)
    }

    private fun showLog(message : String){
        Log.d(TAG, message)
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private fun turnOnVibrationMode()
    {
        val audioManager: AudioManager = baseContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if(Global.getInt(contentResolver, "zen_mode") == 0)
            try {
                audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
            }catch(e:SecurityException){
                showLog(e.toString())
            }
    }


    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private fun setRingVolume(volume:Int)
    {
        val audioManager: AudioManager = baseContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        try{
            audioManager.setStreamVolume(AudioManager.STREAM_RING, volume, 0)
        }catch(e:SecurityException){
            showLog(e.toString())
        }
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private fun setAlarmVolume(volume:Int)
    {
        val audioManager: AudioManager = baseContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        try{
            audioManager.setStreamVolume(AudioManager.STREAM_ALARM, volume, 0)
        }catch(e:SecurityException){
            showLog(e.toString())
        }
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private fun setMusicVolume(volume:Int)
    {
        val audioManager: AudioManager = baseContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        try{
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, volume, 0)
        }catch(e:SecurityException){
            showLog(e.toString())
        }
    }

    private fun popUpNotification(title : String, description : String){
        var builder:NotificationCompat.Builder = NotificationCompat.Builder(this, "FlatMappMesseges")
                .setContentText(description)
                .setContentTitle(title)
                .setSmallIcon(R.drawable.ic_popup_reminder)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
                .setSound(DEFAULT_NOTIFICATION_SOUND)
        with(NotificationManagerCompat.from(this)){
            notify(102, builder.build())
        }
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onHandleIntent(p0: Intent?) {
        while(isRunning) {
            fusedLocationClient.lastLocation
//                    .addOnSuccessListener { location: Location? ->
//                        if (location != null) {
//                            showLog("get location")
//                            popUpNotification("lokalizacja", "latitude: ${location.latitude}, longitude: ${location.longitude}")
//                        }
//                    }
            Thread.sleep(5000)
        }
    }
}
