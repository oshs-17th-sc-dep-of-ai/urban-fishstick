package org.oshssc.oslunch

import android.app.NotificationChannel
import android.app.NotificationManager
import android.util.Log
import android.os.IBinder
import android.app.Service
import android.content.Intent
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.BasicMessageChannel
import org.altbeacon.beacon.*


class BeaconService(private val messageChannel: BasicMessageChannel<String>) : Service(), RangeNotifier {
    private val TAG = "BeaconService"
    private val iBeaconLayout = "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"
    private val enterBeacon =
        Region("CCE99BED-E080-04C4-1A91-1A1A29B64112", null, null, null)  // 10163, BA
    private val exitBeacon =
        Region("CCE99BED-E080-04C4-1A91-1A1A29B64112", null, null, null)  // 10162, C1

    override fun onCreate() {
        super.onCreate()
        val beaconManager = BeaconManager.getInstanceForApplication(this)

        val notificationChannel =
            NotificationChannel("oslunch", "os_lunch", NotificationManager.IMPORTANCE_LOW)
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        notificationChannel.description = "oslunch notification channel"
        notificationManager.createNotificationChannel(notificationChannel)

        val foregroundNotification = NotificationCompat.Builder(this, "oslunch")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("title")
            .setContentText("example text")
            .build()

        // FIXME: not working
        beaconManager.foregroundScanPeriod = 1500L
        beaconManager.backgroundScanPeriod = 1500L
        beaconManager.foregroundBetweenScanPeriod = 1500L
        beaconManager.backgroundBetweenScanPeriod = 1500L
        beaconManager.updateScanPeriods()

        startForeground(8720, foregroundNotification)

        beaconManager.beaconParsers.add(BeaconParser().setBeaconLayout(iBeaconLayout))
        beaconManager.addRangeNotifier(this)
        beaconManager.startRangingBeacons(enterBeacon)
        beaconManager.startRangingBeacons(exitBeacon)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun didRangeBeaconsInRegion(beacons: MutableCollection<Beacon>?, region: Region?) {
        if (beacons == null) {
            return
        }

        Log.d(TAG, "scanned: ${beacons.count()}")
        for (beacon: Beacon in beacons) {
            Log.d(TAG, beacon.toString())
            if (beacon.id2.toInt() == 10162) {
                messageChannel.send("enterBeaconDetected")
                Log.d(TAG, "enterBeacon found: ${beacon.rssi}")
            } else if (beacon.id2.toInt() == 10163)
                messageChannel.send("exitBeaconDetected")
            Log.d(TAG, "exitBeacon found: ${beacon.rssi}")
        }
    }
}
