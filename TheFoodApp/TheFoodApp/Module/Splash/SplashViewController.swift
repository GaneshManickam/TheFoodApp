import Foundation
import RxCocoa
//
//  SplashViewController.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import RxSwift
import UIKit

class SplashViewController: UIViewController {

    var presenter: SplashPresenter?
    var bundle: [String: Any] = [:]
    var delegate: ViewControllerResultDelegate?
    private var disposeBag = DisposeBag()
    fileprivate var isLoading = BehaviorRelay<Bool>(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = bundle[Constants.BundleConstants.delegate] as? ViewControllerResultDelegate {
            self.delegate = delegate
        }
        
        self.initRxBindings()
        self.configureNavigationBar()
    }
    
    /// Function to configure navigation bar
    func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        initViews()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.navigateTo(destination: .foodDetail, bundle: [Constants.BundleConstants.isFromSplash: true])
    }
    
    /// Function to initialize view components
    private func initViews() {
    }
    
    /// Function to call data or perform navigation action on viewWillAppear
    private func initData() {
    }
    
    /// Function to initialize Rx for views and variables
    private func initRxBindings() {
        self.isLoading.asObservable()
            .bind { status in
                if status {
                    AppDelegate.startLoading()
                } else {
                    AppDelegate.finishLoading()
                }
        }
        .disposed(by: disposeBag)
    }
}

extension SplashViewController: ViewControllerResultDelegate {
    func viewControllerResultBundle(bundle: [String : Any]) {
        
    }
}

extension SplashViewController {
}
