//
//  ErrorResponse.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import Mapper

struct ErrorResponse: Mappable, Codable {
    var error: ErrorResponseData?

    init(map: Mapper) throws {
        error = map.optionalFrom("error")
    }
}

struct ErrorResponseData: Mappable, Codable {
    var code: Int?
    var type: String?
    var errors: [String]?
    var error_params: [ErrorParams]?

    init(map: Mapper) throws {
        code = map.optionalFrom("code") ?? 400
        type = map.optionalFrom("type") ?? ""
        errors = map.optionalFrom("errors") ?? []
        error_params = map.optionalFrom("error_params") ?? []
    }
}

struct ErrorParams: Mappable, Codable {
    var param: String?
    var msg: String?

    init(map: Mapper) throws {
        param = map.optionalFrom("param") ?? ""
        msg = map.optionalFrom("msg") ?? ""
    }
}
