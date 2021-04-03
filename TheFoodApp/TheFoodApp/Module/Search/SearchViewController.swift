//
//  SearchViewController.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var presenter: SearchPresenter?
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
        registerTableView()
        self.initRxBindings()
        self.configureNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
// MARK:- UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let query = searchBar.text {
            self.isLoading.accept(true)
            self.presenter?.searchByQuery(parameters: [Constants.ApiConstants.searchSource: query])
        }
    }
}

extension SearchViewController: ViewControllerResultDelegate {
    func viewControllerResultBundle(bundle: [String : Any]) {
        
    }
}

extension SearchViewController {
    
    /**
     Function to perform searchByQuery receipe detail success
     - PARAMETER response: API response
     */
    func searchByQuerySuccess(_ response: Any) {
        self.isLoading.accept(false)
        if let apiResponse = response as? ReceipeDetailRootResponse {
            self.savedList.accept(apiResponse.meals ?? [])
        }
    }
    
    /**
     Function to perform fetch random receipe detail failure
     - PARAMETER error: Instance of `Error`
     */
    func searchByQueryFailure(_ error: Error) {
        self.isLoading.accept(false)
        print("\(error.localizedDescription)")
    }
}
