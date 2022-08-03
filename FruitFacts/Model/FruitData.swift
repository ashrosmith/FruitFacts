//
//  FruitData.swift
//  FruitFacts
//
//  Created by Ashley Smith on 6/27/22.
//

import Foundation

struct FruitData: Codable {
    let name: String
    let family: String
    let nutritions: Nutritions
}

struct Nutritions: Codable {
    let carbohydrates: Double
    let protein: Double
    let fat: Double
    let calories: Double
    let sugar: Double
}
