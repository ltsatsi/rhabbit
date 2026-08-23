import Flutter
import UIKit

// local notifications code
import flutter_local_notifications 


@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // local notifications code
    FlutterLocalNotificationsPlugin.setPluginRegistratrantCallback { (registry) in 
    GeneratedPluginRegistrant.register(with: registry)}

    GeneratePluginRegistrant.register(with: self)

    // local notifications code
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenter
    }


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
