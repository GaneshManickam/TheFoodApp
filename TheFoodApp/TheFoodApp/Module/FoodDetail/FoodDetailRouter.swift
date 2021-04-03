//
//  FoodDetailRouter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import UIKit

class FoodDetailRouter {
    
    /// Initialize FoodDetail module
    static func assembleModule(bundle: [String: Any]) -> UIViewController {
        let viewController = FoodDetailViewController(nibName: "FoodDetailViewController", bundle: nil)
        
        let presenter = FoodDetailPresenter()
        let router = FoodDetailRouter()
        let service = FoodDetailService()
        
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
