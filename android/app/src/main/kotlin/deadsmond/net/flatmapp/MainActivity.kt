package deadsmond.net.flatmapp

import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
//import io.flutter.app.FlutterActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

  lateinit var flatMappServiceIntent:Intent
  var CHANNEL:String = "com.flatmapp.messeges"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    // TODO
    flatMappServiceIntent = Intent(this, FlatMappService::class.java)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      when(call.method){
        "startService" -> {
          startService()
          result.success("Service start was called!")
        }
        "stopService" -> {
          stopService(flatMappServiceIntent)
          result.success("Service stop was called!")
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }

  private fun startService(){
    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
      startForegroundService(flatMappServiceIntent)
    }
    else {
      startService(flatMappServiceIntent)
    }
  }





}