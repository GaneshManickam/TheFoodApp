//
//  SavedListPresenter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SavedListPresenter {
    weak var viewController: SavedListViewController?
    var router: SavedListRouter?
    var service: SavedListService?
    private var disposeBag = DisposeBag()
}
/// ViewController -> Presenter
extension SavedListPresenter {
    /**
     Function to fetch favorite list
     */
    func fetchFavoriteList() {
        DBManager.shared.read(SavedReceipe()) { [weak self] (result) in
            var tempArray: [ReceipeDetailResponse] = []
            for item in result {
                let receipeData = item.getReceipeDetailFromRealm()
                if !(receipeData.idMeal ?? "").isEmpty {
                    tempArray.append(receipeData)
                }
            }
            self?.viewController?.savedList.accept(tempArray)
        }
    }
}

/// Presenter -> Service
extension SavedListPresenter {
    
}

/// Presenter -> Router
extension SavedListPresenter {
    func navigateTo(destination: Destination, bundle: [String: Any]) {
        router?.navigateTo(destination: destination, bundle: bundle)
    }
}
