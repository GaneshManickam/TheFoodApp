//
//  SearchRouter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import UIKit

class SearchRouter {
    
    /// Initialize Search module
    static func assembleModule(bundle: [String: Any]) -> UIViewController {
        let viewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        
        let presenter = SearchPresenter()
        let router = SearchRouter()
        let service = SearchService()
        
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
