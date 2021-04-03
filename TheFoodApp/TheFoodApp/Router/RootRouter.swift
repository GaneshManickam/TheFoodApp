//
//  RootRouter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import UIKit

enum Destination {
    case splash
    case foodDetail
    case favorite
    case search
}

public class RootRouter {
    public init() {}

    func showRootScreen() {
        let viewController = makeViewController(for: Destination.splash, bundle: [:])
        showViewController(viewController, inWindow: AppDelegate.currentWindow)
    }

    /**
     Function to initalize a view controller as Root view controller
     - Parameters:
     - viewController: UIViewController as rootViewController
     - inWindow: UIWindow as app current window
     */
    func showViewController(_ viewController: UIViewController, inWindow: UIWindow) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        inWindow.rootViewController = navigationController
        inWindow.makeKeyAndVisible()
    }

    func navigate(to destination: Destination, bundle: [String: Any], type: Int = 0) {
        if let topViewController = UIApplication.topViewController() {
            switch type {
            case 1:
                let viewController = makeViewController(for: destination, bundle: bundle)
                topViewController.navigationController?.pushViewController(viewController, animated: false)
            case 2:
                let viewController = makeViewController(for: destination, bundle: bundle)
                viewController.modalPresentationStyle = .overCurrentContext
                topViewController.present(viewController, animated: true, completion: nil)
            case 3:
                let viewController = makeViewController(for: destination, bundle: bundle)
                viewController.modalPresentationStyle = .overCurrentContext
                topViewController.present(viewController, animated: false, completion: nil)
            default:
                let viewController = makeViewController(for: destination, bundle: bundle)
                topViewController.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    private func makeViewController(for destination: Destination, bundle: [String: Any]) -> UIViewController {
        switch destination {
        case .splash:
            return SplashRouter.assembleModule(bundle: bundle)
        case .foodDetail:
            return FoodDetailRouter.assembleModule(bundle: bundle)
        case .favorite:
            return SavedListRouter.assembleModule(bundle: bundle)
        case .search:
            return SearchRouter.assembleModule(bundle: bundle)
        }
    }
}
