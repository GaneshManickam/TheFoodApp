//
//  SplashPresenter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SplashPresenter {
    weak var viewController: SplashViewController?
    var router: SplashRouter?
    var service: SplashService?
    private var disposeBag = DisposeBag()
}

/// Presenter -> Service
extension SplashPresenter {
    
}

/// Presenter -> Router
extension SplashPresenter {
    func navigateTo(destination: Destination, bundle: [String: Any]) {
        router?.navigateTo(destination: destination, bundle: bundle)
    }
}
