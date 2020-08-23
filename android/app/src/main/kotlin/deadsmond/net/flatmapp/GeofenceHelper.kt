package deadsmond.net.flatmapp

import android.app.PendingIntent
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofenceStatusCodes
import com.google.android.gms.location.GeofencingRequest
import java.lang.Exception

class GeofenceHelper(base: Context) : ContextWrapper(base) {

    private val TAG:String = "GeofenceHelper"
    private lateinit var pendingIntent: PendingIntent


    fun getGeofencingRequest(geofence: Geofence): GeofencingRequest {
        return GeofencingRequest.Builder()
                .addGeofence(geofence)
                .setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
                .build()
    }

    fun getGeofence(ID:String, latitude:Double, longitude:Double, radius:Float, transitionType:Int): Geofence{
        return Geofence.Builder()
                .setCircularRegion(latitude, longitude, radius)
                .setRequestId(ID)
                .setTransitionTypes(transitionType)
                .setLoiteringDelay(4000)
                .setExpirationDuration(Geofence.NEVER_EXPIRE)
                .build()
    }

    fun getPendingIntent():PendingIntent{
        if(this::pendingIntent.isInitialized) {
            return pendingIntent
        }

        var intent = Intent(this, GeofenceBroadcastReceiver::class.java)
        pendingIntent = PendingIntent.getBroadcast(this, 3251, intent, PendingIntent.FLAG_UPDATE_CURRENT)

        return pendingIntent
    }

    fun getErrorString(e: Exception):String{
        if(e is ApiException)
        {
            var apiException: ApiException = e as ApiException
            when(apiException.statusCode){
                GeofenceStatusCodes.GEOFENCE_NOT_AVAILABLE -> {
                    return "GEOFENCE_NOT_AVAILABLE"
                }
                GeofenceStatusCodes.GEOFENCE_TOO_MANY_GEOFENCES -> {
                    return "GEOFENCE_TOO_MANY_GEOFENCES"
                }
                GeofenceStatusCodes.GEOFENCE_TOO_MANY_PENDING_INTENTS -> {
                    return "GEOFENCE_TOO_MANY_PENDING_INTENTS"
                }

            }
        }
        return e.localizedMessage
    }

}