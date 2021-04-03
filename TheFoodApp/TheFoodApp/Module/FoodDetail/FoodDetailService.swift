//
//  FoodDetailService.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import RxSwift

class FoodDetailService {
    private let facade = HTTPFacade<NetworkTarget>()
    private let disposeBag = DisposeBag()
}

extension FoodDetailService {
    
    /**
     Function to perform fetching random receipe api
     - PARAMETER parameters: Dictionary to hold api parameters
     - RETURNS: API's success or failure callback
     */
    func fetchRandomReceipe(parameters: [String: Any]) -> Single<Data> {
        return Single.create { observer in
            let target = NetworkTarget.fetchRandomReceipe(parameters: parameters)
            self.facade.request(target: target).subscribe(onSuccess: { data in
                observer(.success(data))
            }, onError: { error in
                observer(.error(error))
            }).disposed(by: self.disposeBag)
            return Disposables.create {}
        }
    }
}
