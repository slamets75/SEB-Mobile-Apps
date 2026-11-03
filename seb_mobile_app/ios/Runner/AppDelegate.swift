import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var privacyView: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Listen for screen recording / screen mirroring changes
    if #available(iOS 11.0, *) {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(screenCaptureChanged),
        name: UIScreen.capturedDidChangeNotification,
        object: nil
      )
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Cover screen with privacy overlay when leaving active state (App Switcher protection)
  override func applicationWillResignActive(_ application: UIApplication) {
    super.applicationWillResignActive(application)
    addPrivacyProtection()
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    removePrivacyProtection()
    checkScreenRecording()
  }

  private func addPrivacyProtection() {
    guard privacyView == nil, let window = self.window else { return }
    let view = UIView(frame: window.bounds)
    view.backgroundColor = UIColor(red: 9/255, green: 37/255, blue: 64/255, alpha: 1.0) // STT-NF Dark Blue

    let label = UILabel()
    label.text = "Elena SEB - Layar Dilindungi"
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    privacyView = view
    window.addSubview(view)
  }

  private func removePrivacyProtection() {
    privacyView?.removeFromSuperview()
    privacyView = nil
  }

  @objc private func screenCaptureChanged() {
    checkScreenRecording()
  }

  private func checkScreenRecording() {
    if #available(iOS 11.0, *) {
      if UIScreen.main.isCaptured {
        addPrivacyProtection()
      } else {
        removePrivacyProtection()
      }
    }
  }
}

