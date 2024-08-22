import Flutter
import UIKit
import UserNotifications // 필요한 경우 추가

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // SwiftFlutterBackgroundServicePlugin이 제대로 import되었는지 확인하세요.
    // SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.example.first_snow.bt_foreground"
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}