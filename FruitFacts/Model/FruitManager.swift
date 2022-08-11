//
//  FruitManager.swift
//  FruitFacts
//
//  Created by Ashley Smith on 6/27/22.
//

import UIKit

protocol FruitManagerDelegate {
    func didUpdateFruit(_fruitManager: FruitManager, fruit: FruitModel)
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
        //1. create url
        if let url = URL(string: urlString){
            //2. create url session
            let session = URLSession(configuration: .default)
            
            //3. give session task
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
            //4. start task
            task.resume()
        } else {
            print("Malformed URL.")
        }
    }
    
    
    func parseJSON(fruitData: Data) -> FruitModel? {
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
            let fruitModel = FruitModel(name: name, family: family, carbohydrates: carbohydrates, protein: protein, fat: fat, calories: calories, sugar: sugar)
            return fruitModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
