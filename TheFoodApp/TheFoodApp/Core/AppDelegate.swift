//
//  AppDelegate.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import UIKit
import IQKeyboardManagerSwift
import Toast_Swift
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize window
        window = UIWindow(frame: UIScreen.main.bounds)
        // Initialize Third Party Libraries
        initThirdPartyLibraries()
        // Redirect to root screen
        RootRouter().showRootScreen()
        return true
    }
    
    /**
     Function to initialize third party libraries
     */
    func initThirdPartyLibraries() {
        // Initalize IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        // Limit disk cache size to 1 GB.
        ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
    }
}
extension AppDelegate {
    // AppDelegate instance for access from other classes
    static var currentDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // UIWindow instance for access from other classes
    static var currentWindow: UIWindow {
        return currentDelegate.window!
    }
    
    // Show Root Router
    static func showRootRouter() {
        RootRouter().showRootScreen()
    }
    
    // Loader start
    static func startLoading() {
        getCurrentViewController()?.view.isUserInteractionEnabled = false
        getCurrentViewController()?.view.makeToastActivity(.center)
    }
    
    // Loader finish
    static func finishLoading() {
        getCurrentViewController()?.view.isUserInteractionEnabled = true
        getCurrentViewController()?.view.hideToastActivity()
    }
    
    // Get current view controller instance
    static func getCurrentViewController() -> UIViewController? {
        return UIApplication.topViewController()
    }
    
    // Show Toast
    static func showToast(message: String, isLong: Bool = false) {
        if isLong {
            getCurrentViewController()?.view.makeToast(message, duration: 3.0)
        } else {
            getCurrentViewController()?.view.makeToast(message)
        }
    }
}
