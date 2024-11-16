package org.oshssc.oslunch

import android.util.Log
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

class MainActivity : FlutterActivity() {
    private lateinit var messageChannel: BasicMessageChannel<String>
    private lateinit var beaconService: BeaconService

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        messageChannel = BasicMessageChannel(
            flutterEngine.dartExecutor,
            "org.oshssc.oslunch/message",
            StringCodec.INSTANCE
        )
        beaconService = BeaconService()

        messageChannel.setMessageHandler { message, reply ->
            Log.d("DEBUG", "Received message: $message")

            when (message) {
                "startScan" -> {
                    this.startScan()
                }

                "stopScan" -> {
                    this.stopScan()
                }
            }
        }
    }

    private fun startScan() {
        val intent = Intent(this, beaconService::class.java)
        startService(intent)
        Log.d("FGT", "Foreground Task Started")
    }

    private fun stopScan() {
        val intent = Intent(this, beaconService::class.java)
        stopService(intent)
        Log.d("FGT", "Foreground Task Stopped")
    }
}