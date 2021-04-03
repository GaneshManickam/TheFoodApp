//
//  SavedReceipe.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RealmSwift

class SavedReceipe: Object {
    @objc dynamic var idMeal = ""
    @objc dynamic var strMeal = ""
    @objc dynamic var strCategory = ""
    @objc dynamic var strArea = ""
    @objc dynamic var strInstructions = ""
    @objc dynamic var strMealThumb = ""
    @objc dynamic var strYoutube = ""
    @objc dynamic var ingredients = ""
    
    override class func primaryKey() -> String? {
        return "idMeal"
    }
    
    convenience init(_ receipeDetail: ReceipeDetailResponse) {
        self.init()
        self.idMeal = receipeDetail.idMeal ?? ""
        self.strMeal = receipeDetail.strMeal ?? ""
        self.strCategory = receipeDetail.strCategory ?? ""
        self.strArea = receipeDetail.strArea ?? ""
        self.strInstructions = receipeDetail.strInstructions ?? ""
        self.strMealThumb = receipeDetail.strMealThumb ?? ""
        self.strYoutube = receipeDetail.strYoutube ?? ""
        self.ingredients = receipeDetail.ingredients ?? ""
    }
    
    /**
     Function to get `ReceipeDetailResponse` from the realm object
     */
    func getReceipeDetailFromRealm() -> ReceipeDetailResponse {
        var receipeDetail =  ReceipeDetailResponse()
        receipeDetail.idMeal = self.idMeal
        receipeDetail.strMeal = self.strMeal
        receipeDetail.strCategory = self.strCategory
        receipeDetail.strArea = self.strArea
        receipeDetail.strInstructions = self.strInstructions
        receipeDetail.strMealThumb = self.strMealThumb
        receipeDetail.strYoutube = self.strYoutube
        receipeDetail.ingredients = self.ingredients
        return receipeDetail
    }
}
