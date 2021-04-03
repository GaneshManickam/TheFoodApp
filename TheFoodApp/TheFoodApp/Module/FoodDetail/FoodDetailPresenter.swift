//
//  FoodDetailPresenter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import Mapper

class FoodDetailPresenter {
    weak var viewController: FoodDetailViewController?
    var router: FoodDetailRouter?
    var service: FoodDetailService?
    private var disposeBag = DisposeBag()
    
    var favList: [ReceipeDetailResponse] = []
}
/// ViewController -> Presenter
extension FoodDetailPresenter {
    
    /**
     Function to perform youtube redirection
     - PARAMETER receipeDetail: Instance of `ReceipeDetailResponse`
     */
    func performYoutubeRedirection(_ receipeDetail: ReceipeDetailResponse?) {
        if let urlString = receipeDetail?.strYoutube, !urlString.isEmpty, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /**
     Function to perform favorite action
     - PARAMETER receipeDetail: Instance of `ReceipeDetailResponse`
     */
    func performFavoriteAction() {
        let receipeDetail = self.viewController?.receipeDetail
        let status = self.isReceipePresentInDB(receipeDetail)
        if let receipe = receipeDetail, let idMeal = receipe.idMeal {
            if status {
                DBManager.shared.deleteRealmObject(idMeal: idMeal)
            } else {
                let realmObject = receipe.getRealmObjectFromReceipeDetail()
                DBManager.shared.create(realmObject)
            }
        }
        
        self.fetchFavoriteList()
    }
    
    /**
     Function to fetch favorite list
     */
    func fetchFavoriteList() {
        favList = []
        DBManager.shared.read(SavedReceipe()) { [weak self] (result) in
            self?.favList = []
            for item in result {
                let receipeData = item.getReceipeDetailFromRealm()
                self?.favList.append(receipeData)
            }
            self?.viewController?.updateSavedStatus()
        }
    }
    
    /**
     Function to check whether receipe present in DB
     - PARAMETER receipeDetail: Instance of `ReceipeDetailResponse`
     - RETURN: `Bool` value
     */
    func isReceipePresentInDB(_ receipeDetail: ReceipeDetailResponse?) -> Bool {
        if let receipeId = receipeDetail?.idMeal {
            let filteredArray = self.favList.filter {
                $0.idMeal == receipeId
            }
            
            return filteredArray.count > 0
        } else {
            return false
        }
    }
}

/// Presenter -> Service
extension FoodDetailPresenter {
    /**
     Function to perform user login api call
     - PARAMETER parameters: Dictonary value to hold api parameters
     */
    func fetchRandomReceipe(parameters: [String: Any]) {
        service?.fetchRandomReceipe(parameters: parameters).subscribe(onSuccess: { data in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let JSON: NSDictionary = json as? NSDictionary {
                    if let response = ReceipeDetailRootResponse.from(JSON) {
                        self.viewController?.fetchRandomReceipeDetailSuccess(response)
                    }
                }
            } catch {}
        }, onError: { error in
            self.viewController?.fetchRandomReceipeDetailFailure(error)
        }).disposed(by: disposeBag)
    }
}

/// Presenter -> Router
extension FoodDetailPresenter {
    func navigateTo(destination: Destination, bundle: [String: Any]) {
        router?.navigateTo(destination: destination, bundle: bundle)
    }
}
