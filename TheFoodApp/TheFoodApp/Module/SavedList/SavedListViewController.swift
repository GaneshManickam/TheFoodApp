//
//  SavedListViewController.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SavedListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: SavedListPresenter?
    var bundle: [String: Any] = [:]
    var delegate: ViewControllerResultDelegate?
    private var disposeBag = DisposeBag()
    fileprivate var isLoading = BehaviorRelay<Bool>(value: false)
    let savedList = BehaviorRelay<[ReceipeDetailResponse]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = bundle[Constants.BundleConstants.delegate] as? ViewControllerResultDelegate {
            self.delegate = delegate
        }
        self.registerTableView()
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
    
    /// Function to initialize view components
    private func initViews() {
    }
    
    /// Function to call data or perform navigation action on viewWillAppear
    private func initData() {
        self.presenter?.fetchFavoriteList()
    }
    
    private func registerTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.tableView.register(UINib(nibName: "SavedListTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedListTableViewCell")
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    /// Function to initialize Rx for views and variables
    private func initRxBindings() {
        isLoading
            .asObservable()
            .bind { status in
                if status {
                    AppDelegate.startLoading()
                } else {
                    AppDelegate.finishLoading()
                }
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        savedList.asObservable().bind(to: tableView.rx.items(cellIdentifier: "SavedListTableViewCell", cellType: SavedListTableViewCell.self)) { (row, item, cell) in
            cell.updateCellBy(item)
            
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ReceipeDetailResponse.self).subscribe(onNext: { item in
            self.presenter?.navigateTo(destination: .foodDetail, bundle: [Constants.BundleConstants.isFromSplash: false, Constants.BundleConstants.savedReceipe: item])
        }).disposed(by: disposeBag)
    }
}

extension SavedListViewController: ViewControllerResultDelegate {
    func viewControllerResultBundle(bundle: [String : Any]) {
        
    }
}

extension SavedListViewController {
}
