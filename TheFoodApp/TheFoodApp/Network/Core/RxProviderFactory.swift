//
//  RxProviderFactory.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import Alamofire
import Foundation
import Moya

public final class MoyaProviderFactory<TypeOfTarget: NetworkTargetType> {
    private lazy var endPointClosure: (TypeOfTarget) -> Endpoint = { { (target: TypeOfTarget) -> Endpoint in

        let endpoint = Endpoint(url: target.baseURL.absoluteString + target.path,
                                sampleResponseClosure: target.sampleResponseClosure,
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.httpHeader)

        return endpoint
    }
    }()

    public func moyaProvider() -> MoyaProvider<TypeOfTarget> {
        return MoyaProvider<TypeOfTarget>(endpointClosure: endPointClosure, session: defaultAlamofireManager())
    }

    public func defaultAlamofireManager() -> Session {
        let capacity = 50 * 1024 * 1024
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = 30
        return Session(configuration: configuration)
    }
}
