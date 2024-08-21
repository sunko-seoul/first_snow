import Flutter
import UIKit
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var bleManager: BLEManager?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    
    // FlutterViewController 가져오기
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    // FlutterMethodChannel 생성
    
    bleManager = BLEManager()
    let bleMethodChannel = FlutterMethodChannel(name: "ble_advertise_scanner", binaryMessenger: controller.binaryMessenger)
    bleManager?.setMethodChannel(bleMethodChannel)

    bleMethodChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
        guard let bleManager = self?.bleManager else {
                   result(FlutterError(code: "BLE_ERROR", message: "BLEManager is not initialized", details: nil))
                   return
       }
        // 호출된 메서드 처리
        switch call.method {
        case "startAdvertise":
            bleManager.startAdvertising()
            result("Started Advertising")
        case "startScan":
            bleManager.startScan()
            result("Started Scanning")
        default:
            result(FlutterMethodNotImplemented)
        }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
