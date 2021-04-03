//
//  SavedListRouter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import UIKit

class SavedListRouter {
    
    /// Initialize SavedList module
    static func assembleModule(bundle: [String: Any]) -> UIViewController {
        let viewController = SavedListViewController(nibName: "SavedListViewController", bundle: nil)
        
        let presenter = SavedListPresenter()
        let router = SavedListRouter()
        let service = SavedListService()
        
        presenter.service = service
        presenter.viewController = viewController
        presenter.router = router
        
        viewController.bundle = bundle
        viewController.presenter = presenter
        
        return viewController
    }
    
    func navigateTo(destination: Destination, bundle: [String: Any]) {
        RootRouter().navigate(to: destination, bundle: bundle)
    }
}
