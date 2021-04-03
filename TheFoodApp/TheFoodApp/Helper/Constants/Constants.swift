//
//  Constants.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation

struct Constants {
    
    struct URLs {
        static let base_url = "https://www.themealdb.com/api/json/v1/1"
    }
    
    struct ApiConstants {
        static let action = "action"
        static let searchSource = "s"
    }
    
    struct ApiPathConstants {
        static let fetchRandomReceipe = "/random.php"
        static let searchByQuery = "/search.php"
    }
    
    struct BundleConstants {
        static let delegate = "delegate"
        static let isFromSplash = "isFromSplash"
        static let savedReceipe = "savedReceipe"
    }
    
}
