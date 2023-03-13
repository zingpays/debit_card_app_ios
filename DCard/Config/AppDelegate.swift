//
//  AppDelegate.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/3.
//

import UIKit
import IQKeyboardManagerSwift
import GKNavigationBarSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupEnvironment()
        setupNavBar()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.rootViewController = rootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
}

extension UIApplicationDelegate {

    /// App root viewcontroller
    /// - Returns: root vc
    func rootViewController() -> UIViewController {
        if UserManager.shared.token == nil {
            if UserDefaults.standard.value(forKey: APPISSHOWGUIDEKEY) == nil {
                let guideVC = GuideViewController()
                let guideNavVC = UINavigationController(rootViewController: guideVC)
                return guideNavVC
            } else {
                let vc = LoginViewController()
                let loginNavVC = UINavigationController(rootViewController: vc)
                return loginNavVC
            }
        } else {
            return TabBarController()
        }
    }

    /// Reset app root viewcontroller and sub viewcontroller
    func rebootApplication() {
        let rootVC = TabBarController()
        let homeVC = rootVC.viewControllers?.first as? UINavigationController
        // rebuild nav structure
        let vc = UserCenterViewController()
        vc.hidesBottomBarWhenPushed = true
        let languageVC = LanguageSettingViewController()
        homeVC?.viewControllers.append(vc)
        homeVC?.viewControllers.append(languageVC)
        UIApplication.shared.keyWindow()?.rootViewController = rootVC
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
        let resignedClasses = [RegisterViewController.self,
                               SettingPasswordViewController.self,
                               BindPhoneViewController.self,
                               FillInNameAndNationalViewController.self,
                               LoginViewController.self,
                               PasswordLoginViewController.self,
                               FillInAddressViewController.self,
                               SecurityVerificationViewController.self,
                               ForgotPasswordEmailCheckViewController.self,
                               SecurityVerificationViewController.self,                               SellCryptoViewController.self,
                               WithdrawViewController.self,
                               KYCFillInNameAndNationalViewController.self,
                               FillInAddressViewController.self,
                               ChangePasswordViewController.self]
        IQKeyboardManager.shared.enabledTouchResignedClasses = resignedClasses
    }
    
    func setupNavBar() {
        GKConfigure.setupDefault()
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
