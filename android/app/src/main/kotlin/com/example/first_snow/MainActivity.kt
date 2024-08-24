package com.example.first_snow

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import kotlinx.coroutines.*


class MainActivity : FlutterActivity() {
  private val CHANNEL = "com.example.first_snow/android"
    private val bTScan: BTScan = BTScan(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{ 
                    call, result -> 
                      if (call.method == "browseNaver") {
                        // val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.naver.com"));
                        // startActivity(intent);
                        result.success(1);
                      } else if (call.method == "BTScanning") {
                          CoroutineScope(Dispatchers.Main).launch {
                              val jsonBTScan = bTScan.scanBTForPeriod(10)
                              result.success(jsonBTScan)
                          }
                      } else if (call.method == "BTAdvertising") {
                          bTScan.startAdvertising()
                      }
                      else {
                        result.notImplemented();
                      }
                    
    }
  }
}
