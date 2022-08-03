//
//  Fruit+CoreDataProperties.swift
//  FruitFacts
//
//  Created by Ashley Smith on 6/27/22.
//
//

import Foundation
import CoreData


extension Fruit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fruit> {
        return NSFetchRequest<Fruit>(entityName: "Fruit")
    }

    @NSManaged public var name: String?
}

extension Fruit : Identifiable {

}
