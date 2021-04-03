//
//  SearchPresenter.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SearchPresenter {
    weak var viewController: SearchViewController?
    var router: SearchRouter?
    var service: SearchService?
    private var disposeBag = DisposeBag()
}

/// Presenter -> Service
extension SearchPresenter {
    /**
     Function to perform user login api call
     - PARAMETER parameters: Dictonary value to hold api parameters
     */
    func searchByQuery(parameters: [String: Any]) {
        service?.searchByQuery(parameters: parameters).subscribe(onSuccess: { data in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let JSON: NSDictionary = json as? NSDictionary {
                    if let response = ReceipeDetailRootResponse.from(JSON) {
                        self.viewController?.searchByQuerySuccess(response)
                    }
                }
            } catch {}
        }, onError: { error in
            self.viewController?.searchByQueryFailure(error)
        }).disposed(by: disposeBag)
    }
}

/// Presenter -> Router
extension SearchPresenter {
    func navigateTo(destination: Destination, bundle: [String: Any]) {
        router?.navigateTo(destination: destination, bundle: bundle)
    }
}
