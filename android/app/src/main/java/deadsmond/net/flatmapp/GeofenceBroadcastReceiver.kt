package deadsmond.net.flatmapp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.nfc.Tag
import android.os.AsyncTask
import android.util.JsonReader
import android.util.Log
import androidx.core.R
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent
import java.io.*
import java.lang.Exception

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    val TAG = "GeofenceBroadcast"
    val DEFAULT_NOTIFICATION_SOUND: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
    var activatedNow = mutableSetOf<String>()

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
                    }
                }
            }catch(e:Exception)
            {
                e.printStackTrace()
            }
            return null
        }



    }

}
