//
//  FoodDetailViewController.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class FoodDetailViewController: UIViewController {

    @IBOutlet weak var baseView: UIView!
    // Navigation Bar
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoriteListButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    // Content Body
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var receipeNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var receipeImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var ingredientTitleLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var instructionTitleLabel: UILabel!
    @IBOutlet weak var instructtionLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    
    
    var presenter: FoodDetailPresenter?
    var bundle: [String: Any] = [:]
    var delegate: ViewControllerResultDelegate?
    private var disposeBag = DisposeBag()
    fileprivate var isLoading = BehaviorRelay<Bool>(value: false)
    
    var receipeDetail: ReceipeDetailResponse?

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
    
    /// Function to initialize view components
    private func initViews() {
        self.receipeImageView.layer.cornerRadius = 10
        self.receipeImageView.clipsToBounds = true
        let isFromSplash = self.bundle[Constants.BundleConstants.isFromSplash] as? Bool ?? false
        self.backButton.isHidden = isFromSplash
        self.searchButton.isHidden = !isFromSplash
        self.favoriteListButton.isHidden = !isFromSplash
        self.refreshButton.isHidden = !isFromSplash
    }
    
    /// Function to call data or perform navigation action on viewWillAppear
    private func initData() {
        self.presenter?.fetchFavoriteList()
        let isFromSplash = self.bundle[Constants.BundleConstants.isFromSplash] as? Bool ?? false
        if !isFromSplash, let receipeData = self.bundle[Constants.BundleConstants.savedReceipe] as? ReceipeDetailResponse {
            self.receipeDetail = receipeData
            self.updateReceipeDetail()
        } else {
            self.isLoading.accept(true)
            self.presenter?.fetchRandomReceipe(parameters: [:])
        }
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
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        self.searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter?.navigateTo(destination: .search, bundle: [:])
            }).disposed(by: disposeBag)
        
        self.favoriteListButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter?.navigateTo(destination: .favorite, bundle: [:])
            }).disposed(by: disposeBag)

        self.refreshButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isLoading.accept(true)
                self?.presenter?.fetchRandomReceipe(parameters: [:])
            }).disposed(by: disposeBag)
        
        self.favoriteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter?.performFavoriteAction()
            }).disposed(by: disposeBag)

        self.youtubeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter?.performYoutubeRedirection(self?.receipeDetail)
            }).disposed(by: disposeBag)

    }
}
// MARK:- Support Functions
extension FoodDetailViewController {
    /**
     Function to update receipe detail
     */
    fileprivate func updateReceipeDetail() {
        self.contentView.isHidden = false
        self.receipeNameLabel.text = self.receipeDetail?.strMeal ?? ""
        var categoryName = self.receipeDetail?.strCategory ?? ""
        if !categoryName.isEmpty {
            categoryName += " "
        }
        if let areaName = self.receipeDetail?.strArea, !areaName.isEmpty {
            categoryName += "(\(areaName))"
        }
        
        self.categoryLabel.text = categoryName
        if let imgUrl = URL(string: self.receipeDetail?.strMealThumb ?? "") {
            self.receipeImageView.kf.setImage(with: imgUrl)
        }
        self.instructtionLabel.text = self.receipeDetail?.strInstructions ?? ""
        self.ingredientLabel.text = self.receipeDetail?.ingredients ?? ""
        if let youTubeStr = self.receipeDetail?.strYoutube, !youTubeStr.isEmpty {
            self.youtubeButton.isHidden = false
        } else {
            self.youtubeButton.isHidden = true
        }
        
        updateSavedStatus()
    }
}
// MARK:- Presenter Callback
extension FoodDetailViewController {
    
    /**
     Function to perform fetch random receipe detail success
     - PARAMETER response: API response
     */
    func fetchRandomReceipeDetailSuccess(_ response: Any) {
        self.isLoading.accept(false)
        if let apiResponse = response as? ReceipeDetailRootResponse {
            self.receipeDetail = apiResponse.meals?.first
            self.updateReceipeDetail()
        }
    }
    
    /**
     Function to perform fetch random receipe detail failure
     - PARAMETER error: Instance of `Error`
     */
    func fetchRandomReceipeDetailFailure(_ error: Error) {
        self.isLoading.accept(false)
        print("\(error.localizedDescription)")
    }
    
    /**
     Function to update saved status
     */
    func updateSavedStatus() {
        let status = self.presenter?.isReceipePresentInDB(self.receipeDetail) ?? false
        self.favoriteButton.setImage(status ? UIImage(named: "ic_heart_filled")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_heart_outline")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
}
// MARK:- ViewControllerResultDelegate
extension FoodDetailViewController: ViewControllerResultDelegate {
    func viewControllerResultBundle(bundle: [String : Any]) {
        
    }
}
