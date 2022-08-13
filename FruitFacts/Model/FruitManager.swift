//
//  FruitManager.swift
//  FruitFacts
//
//  Created by Ashley Smith on 6/27/22.
//

import UIKit

protocol FruitManagerDelegate {
    func didUpdateFruit(_fruitManager: FruitManager, fruit: ParsedFruitData)
    func didFailWithError(error: Error)
}

public struct FruitManager {
    let fruitURL = "https://www.fruityvice.com/api/fruit"
    var delegate: FruitManagerDelegate?
    
    func fetchData(fruitName: String) {
        let urlString = "\(fruitURL)/\(fruitName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession.shared

            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let fruit = self.parseJSON(fruitData: safeData) {
                        self.delegate?.didUpdateFruit(_fruitManager: self, fruit: fruit)
                    }
                }
            }
            task.resume()
        } else {
            print("Malformed URL.")
        }
    }
    
    
    func parseJSON(fruitData: Data) -> ParsedFruitData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FruitData.self, from: fruitData)
            let name = decodedData.name
            let family = decodedData.family
            let carbohydrates = decodedData.nutritions.carbohydrates
            let protein = decodedData.nutritions.protein
            let fat = decodedData.nutritions.fat
            let calories = decodedData.nutritions.calories
            let sugar = decodedData.nutritions.sugar
            let fruitFacts = ParsedFruitData(name: name, family: family, carbohydrates: carbohydrates, protein: protein, fat: fat, calories: calories, sugar: sugar)
            return fruitFacts
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
