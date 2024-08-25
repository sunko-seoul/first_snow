package com.example.first_snow

import android.annotation.SuppressLint
import android.bluetooth.le.ScanResult
import android.content.Context
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanSettings
import android.os.ParcelUuid
import kotlinx.coroutines.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.encodeToString

const val PERMISSION_REQUEST_CODE = 1

class BTScan(private val activity: Activity) {

    // FSN == "46534e", M == "4d", DummyData == "0000-0000", UserID == extra 8byte
    private val firstSnowUuid: String = "46534e4d-0000-0000-b51b-aae3868967ed"

    private val bluetoothAdapter: BluetoothAdapter by lazy {
        val bluetoothManager = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        // turn on, turn off, scan, connect, get info...
        bluetoothManager.adapter
    }

    private val bleScanner by lazy {
        bluetoothAdapter.bluetoothLeScanner
    }

    private val bleAdvertiser by lazy {
        bluetoothAdapter.bluetoothLeAdvertiser
    }

    // SCAN_MODE_LOW_LATENCY: brief period, specific type
    // SCAN_MODE_LOW_POWER: longer period, background
    private val scanSettings = ScanSettings.Builder()
        .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
        .build()

    private var isScanning = false
        set(value) {
            field = value
        }

    private val scanResults = mutableListOf<ScanResult>()

    private val scanUuidResults = mutableListOf<ParcelUuid>()


    private fun startBTScan() {
        if (!activity.hasRequiredBluetoothPermissions()) {
            activity.requestRelevantBluetoothPermissions(PERMISSION_REQUEST_CODE)
        } else {
            try {
                scanUuidResults.clear()
                bleScanner.startScan(null, scanSettings, scanCallback)
                isScanning = true
            } catch (e:SecurityException) {
                print(e.message)
            }
        }
    }

    @SuppressLint("MissingPermission")
    private fun stopBTScan() {
        if (activity.hasRequiredBluetoothPermissions()) {
            bleScanner.stopScan(scanCallback)
            isScanning = false
        }
    }

    private var scanJob: Job? = null

    private fun getScanResultsJson(): String {
        // uuid 안의 중복값 제거
        val result = scanUuidResults.distinct().map {
            it.toString()
        }
        return Json.encodeToString(result)
    }

    suspend fun scanBTForPeriod(seconds: Long): String {
        if (!isScanning) {
            return withContext(Dispatchers.IO) {
                startBTScan()
                delay(seconds * 1000)
                stopBTScan()
                isScanning = true
                getScanResultsJson()
            }
        } else {
            isScanning = false
            scanJob?.cancel()
            return scanBTForPeriod(seconds)
        }
    }

    fun startAdvertising() {
        val advertisingSettings = AdvertiseSettings.Builder().setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER)
            .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH).setConnectable(false).build()
        val advertisingData = AdvertiseData.Builder().setIncludeDeviceName(true)
            .addServiceUuid(ParcelUuid.fromString(firstSnowUuid)).build()

        bleAdvertiser.startAdvertising(advertisingSettings, advertisingData, advertiseCallback)
    }

    private val advertiseCallback = object: AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
            super.onStartSuccess(settingsInEffect)
            // 광고 시작 성공
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
            // 광고 시작 실패 처리
        }
    }

    // ignore warning if it's ignorable
    @SuppressLint("MissingPermission")
    private val scanCallback = object: ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            val scanRecord = result.scanRecord
            scanRecord?.serviceUuids?.map {
                if (it.toString().substring(0, 6) == "46534e") {
                    scanUuidResults.add(it)
                }
            }
//            if (scanRecord is ScanRecord && scanRecord.serviceUuids != null) { // if address alread exists, replace it
//                for (uuid in scanRecord.serviceUuids) {
//                    // Chk Service Identifier
//                    if (uuid.toString().substring(0, 6) == "46534e") {
//                    }
//                }
//            }
        }
    }

}


