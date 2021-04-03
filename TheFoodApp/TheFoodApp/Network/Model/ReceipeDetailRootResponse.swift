//
//  ReceipeDetailRootResponse.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import Mapper

struct ReceipeDetailRootResponse: Mappable, Codable {
    var meals: [ReceipeDetailResponse]?
    
    init(map: Mapper) throws {
        meals = map.optionalFrom("meals")
    }
}
struct ReceipeDetailResponse: Mappable, Codable {
    var idMeal: String?
    var strMeal: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
    var strYoutube: String?
    var ingredients: String?

    init(map: Mapper) throws {
        idMeal = map.optionalFrom("idMeal")
        strMeal = map.optionalFrom("strMeal")
        strCategory = map.optionalFrom("strCategory")
        strArea = map.optionalFrom("strArea")
        strInstructions = map.optionalFrom("strInstructions")
        strMealThumb = map.optionalFrom("strMealThumb")
        strYoutube = map.optionalFrom("strYoutube")
        ingredients = nil
        for i in 1 ... 20 {
            let ingredient: String? = map.optionalFrom("strIngredient\(i)")
            let measurement: String? = map.optionalFrom("strMeasure\(i)")
            if let ingredientValue = ingredient, ingredientValue != "", ingredientValue != " "  {
                if ingredients == nil {
                    ingredients = ingredientValue
                } else {
                    ingredients! += "\n" + ingredientValue
                }
            }
            
            if let measurementValue = measurement, measurementValue != "", measurementValue != " " {
                if ingredients == nil {
                    ingredients = measurementValue
                } else {
                    ingredients! += " - " + measurementValue
                }
            }
        }
    }
    
    init() {
    }
    
    /**
     Function to get realm object from the receipe detail
     - RETURNS: `SavedReceipe`
     */
    func getRealmObjectFromReceipeDetail() -> SavedReceipe {
        return SavedReceipe(self)
    }
}
