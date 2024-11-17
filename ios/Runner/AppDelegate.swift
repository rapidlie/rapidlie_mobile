import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let googleMapsApiKey = Bundle.main.object(forInfoDictionaryKey: "GMS_API_KEY") as? String {
      GMSServices.provideAPIKey(googleMapsApiKey)
    } 
    else {
      print("Google Maps API Key not found in Info.plist")
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
