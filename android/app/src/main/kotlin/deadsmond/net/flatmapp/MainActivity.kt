package deadsmond.net.flatmapp

import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices
import io.flutter.Log
//import io.flutter.app.FlutterActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception


class MainActivity: FlutterActivity() {

  val TAG = "MainActivity"
//  lateinit var flatMappServiceIntent:Intent
  var CHANNEL:String = "com.flatmapp.messeges"
  private lateinit var geofencingClient: GeofencingClient
  private lateinit var geofenceHelper: GeofenceHelper

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    // TODO
    geofencingClient = LocationServices.getGeofencingClient(this)
    geofenceHelper = GeofenceHelper(this)
    //addGeofence("[#148b5]", 52.4669, 16.9270, 100.0F)
//    flatMappServiceIntent = Intent(this, FlatMappService::class.java)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      when(call.method){
//        "startService" -> {
//          startService()
//          result.success("Service start was called!")
//        }
//        "stopService" -> {
//          stopService(flatMappServiceIntent)
//          result.success("Service stop was called!")
//        }
        "addMarker" ->
        {
          var marker: String? = call.argument<String>("marker")
          if(marker != null)
          {
           var parameters:List<String> = marker.split(";")
            if(parameters.size == 4)
            {
              addGeofence(parameters[0], parameters[1].toDouble(), parameters[2].toDouble(), parameters[3].toFloat())
            }
          }
        }
        "deleteMarkers" ->
        {
          var markers: String? = call.argument<String>("markers")
          if(markers != null)
          {
            for(ID in markers.split(";"))
            {
              deleteGeofence(ID)
            }
          }
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }

//  private fun startService(){
//    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
//      startForegroundService(flatMappServiceIntent)
//    }
//    else {
//      startService(flatMappServiceIntent)
//    }
//  }

  fun addGeofence(ID:String, latitude:Double, longitude:Double, radius:Float){
    var geofence: Geofence = geofenceHelper.getGeofence(ID, latitude, longitude, radius, Geofence.GEOFENCE_TRANSITION_DWELL)
    var geofencingRequest: GeofencingRequest = geofenceHelper.getGeofencingRequest(geofence)
    var pendingIntent: PendingIntent = geofenceHelper.getPendingIntent()
    geofencingClient.addGeofences(geofencingRequest, pendingIntent)
            .addOnSuccessListener { Log.d(TAG, "addGeofence onSuccess: Geofence $ID Added...")}
            .addOnFailureListener {
              var errorMassage:String = geofenceHelper.getErrorString(it)
              Log.d(TAG, "addGeofence onFailure: $errorMassage")
            }
  }

  fun deleteGeofence(ID: String){
    var list:MutableList<String> = MutableList(1){ID}
    try {
      geofencingClient.removeGeofences(list)
              .addOnSuccessListener{Log.d(TAG, "deleteGeofence onSuccess: Geofence $ID Deleted...")}
              .addOnFailureListener{
                Log.d(TAG, "deleteGeofence onFailure: $it")
              }
    }catch (e:Exception)
    {
      Log.d(TAG, "Delete geofence error: $e")
    }
  }



}