import UIKit
import Flutter
import GoogleMaps // Required for GMSServices

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Provide Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDaehUmhV5GS62I-7BOVBe_wss0HI-2GJk")
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set notification delegate for iOS 10+import UIKit
import Flutter
import GoogleMaps // Required for GMSServices

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Provide Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDaehUmhV5GS62I-7BOVBe_wss0HI-2GJk")
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set notification delegate for iOS 10+
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
