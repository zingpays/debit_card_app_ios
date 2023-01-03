//
//  AppDelegate.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/3.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupEnvironment()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
}

extension UIApplicationDelegate {

    /// App root viewcontroller
    /// - Returns: root vc
    func rootViewController() -> UIViewController {
        return HomeViewController()
    }

    /// Reset app root viewcontroller and sub viewcontroller
    func rebootApplication() {
        // Maybe rewrite this logic due to release feture.
        // https://juejin.cn/post/6844903687991590920
        // https://www.cxyzjd.com/article/Forever_wj/108210234
        UIApplication.shared.keyWindow()?.rootViewController = rootViewController()
    }
}

extension AppDelegate {
    /// Set up app environment
    func setupEnvironment() {
        // Set up app language
        LocalizationManager.shared.setupLanguage()
        // Set up keyboard manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        let resignedClasses = [HomeViewController.self]
        IQKeyboardManager.shared.enabledTouchResignedClasses = resignedClasses
    }
}

extension UIApplication {
    /// App key window
    /// - Returns: window
    func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
                        .filter({ $0.activationState == .foregroundActive })
                        .map({ $0 as? UIWindowScene })
                        .compactMap({ $0 })
                        .last?.windows
                        .filter({ $0.isKeyWindow })
                        .last
    }
}
