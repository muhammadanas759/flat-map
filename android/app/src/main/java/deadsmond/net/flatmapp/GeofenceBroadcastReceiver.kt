package deadsmond.net.flatmapp

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.net.wifi.WifiManager
import android.os.AsyncTask
import android.os.Build
import android.util.JsonReader
import android.util.Log
import androidx.annotation.RequiresApi
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent
import java.io.*
import java.lang.Exception

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    val TAG = "GeofenceBroadcast"

    override fun onReceive(context: Context, intent: Intent) {
        // This method is called when the BroadcastReceiver is receiving an Intent broadcast.
        Log.d(TAG, "onReceive: Geofence triggered.")
        var geofencingEvent:GeofencingEvent = GeofencingEvent.fromIntent(intent)
        if(geofencingEvent.hasError())
        {
            Log.d(TAG, "onReceive: Error receiving geofence event...")
            return
        }

        var pendingResult:PendingResult = goAsync()
        Task(pendingResult, intent, context).execute(geofencingEvent.triggeringGeofences)

    }

    class Task(var pendingResult: PendingResult, var intent: Intent, var context: Context) : AsyncTask<List<Geofence>, Void, Void>() {

        val TAG = "flutterBackground"

        override fun onPostExecute(result: Void?) {
            super.onPostExecute(result)
            pendingResult.finish()
        }

        override fun doInBackground(vararg p0: List<Geofence>?): Void? {
            try {
                var notificationHelper:NotificationHelper = NotificationHelper(context)
                var markerPath = context.filesDir.path + "/../app_flutter"
                var markerFile = File(markerPath + "/marker_storage.json")
                var markerMap = HashMap<String, ArrayList<Action>>()
                Log.i(TAG, markerFile.readText())
                for(geofence:Geofence in p0[0]!!)
                {
                    var geo:Geofence = geofence
                    markerMap[geo.requestId] = ArrayList()
                }
                val targetStream: InputStream = FileInputStream(markerFile)
                val reader = JsonReader(InputStreamReader(targetStream, "UTF-8"))
                reader.beginObject()
                while (reader.hasNext()) {
                    var name = reader.nextName()
                    if (name in markerMap.keys) {
                        reader.beginObject()
                        while (reader.hasNext()) {
                            var name2 = reader.nextName()
                            when (name2) {
                                "actions" -> {
                                    reader.beginArray()
                                    while (reader.hasNext()) {
                                        var action = Action()
                                        reader.beginObject()
                                        while (reader.hasNext()) {
                                            var name3 = reader.nextName()
                                            when (name3) {
                                                "Action_Name" -> {
                                                    action.name = reader.nextString()
                                                }
                                                "action_detail" -> {
                                                    var params = reader.nextString()
                                                    val paramsStream: InputStream = ByteArrayInputStream(params.toByteArray(Charsets.UTF_8))
                                                    val paramReader = JsonReader(InputStreamReader(paramsStream, "UTF-8"))
                                                    paramReader.beginObject()
                                                    while (paramReader.hasNext()) {
                                                        val paramName = paramReader.nextName()
                                                        when (paramName) {
                                                            "param1" -> {
                                                                action.params[0] = paramReader.nextString()
                                                            }
                                                            "param2" -> {
                                                                action.params[1] = paramReader.nextString()
                                                            }
                                                            "param3" -> {
                                                                action.params[2] = paramReader.nextString()
                                                            }
                                                            "param4" -> {
                                                                action.params[3] = paramReader.nextString()
                                                            }
                                                            "param5" -> {
                                                                action.params[4] = paramReader.nextString()
                                                            }
                                                            else -> {
                                                                paramReader.skipValue()
                                                            }
                                                        }
                                                    }
                                                    paramReader.endObject()
                                                    paramsStream.close()
                                                }
                                                else -> {
                                                    reader.skipValue()
                                                }
                                            }
                                        }
                                        reader.endObject()
                                        markerMap[name]?.add(action)
                                    }
                                    reader.endArray()
                                }
                                else -> {
                                    reader.skipValue()
                                }
                            }
                        }
                        reader.endObject()
                    }
                    else{
                        reader.skipValue()
                    }
                }
                reader.endObject()
                targetStream.close()
                for(marker:String in markerMap.keys)
                {
                    Log.i(TAG, "$marker's list of actions:")
                    for(action:Action in markerMap[marker]!!)
                    {
                        Log.i(TAG, action.name)
                        when(action.name)
                        {
                            "notification" ->
                            {
                                notificationHelper.sendHighPriorityNotification(action.params[0], action.params[1], MainActivity::class.java)
                                Log.i(TAG, "called notification action")
                            }
                            "mute" ->
                            {
                                Log.i(TAG, "called mute action")
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                                    setRingVolume(0)
                                    setAlarmVolume(0)
                                    setMusicVolume(0)
                                }
                            }
                            "wi-fi" ->
                            {
                                Log.i(TAG, "called wifi action")
                            }
                            "bluetooth" ->
                            {
                                Log.i(TAG, "called bluetooth action")
                            }
                            else ->
                            {
                                Log.i(TAG, "called not implemented action ${action.name}")
                            }
                        }
                    }
                }
            }catch(e:Exception)
            {
                e.printStackTrace()
            }
            return null
        }


        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        private fun setRingVolume(volume:Int)
        {
            val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            try{
                audioManager.setStreamVolume(AudioManager.STREAM_RING, volume, 0)
            }catch(e:SecurityException){
                Log.i(TAG, e.toString())
            }
        }

        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        private fun setAlarmVolume(volume:Int)
        {
            val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            try{
                audioManager.setStreamVolume(AudioManager.STREAM_ALARM, volume, 0)
            }catch(e:SecurityException){
                Log.i(TAG, e.toString())
            }
        }

        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        private fun setMusicVolume(volume:Int)
        {
            val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            try{
                audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, volume, 0)
            }catch(e:SecurityException){
                Log.i(TAG, e.toString())
            }
        }

        private fun enableWIFI()
        {
            val wifiManager: WifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            wifiManager.isWifiEnabled = true
        }


        private fun disableWIFI()
        {
            val wifiManager: WifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            wifiManager.isWifiEnabled = false
        }

        private fun enableBluetooth()
        {
            val bluetoothAdapter: BluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if(!bluetoothAdapter.isEnabled)
                bluetoothAdapter.enable()
        }

        private fun disableBluetooth()
        {
            val bluetoothAdapter: BluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if(bluetoothAdapter.isEnabled)
                bluetoothAdapter.disable()
        }

    }

}
