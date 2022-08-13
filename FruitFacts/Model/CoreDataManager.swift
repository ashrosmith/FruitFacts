//
//  CoreDataManager.swift
//  FruitFacts
//
//  Created by Ashley Smith on 8/13/22.
//

import Foundation
import CoreData

public struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name:"FruitFacts")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()
    
    func createFruit(name: String) -> Fruit? {
        let context = persistentContainer.viewContext
        let fruit = Fruit(context: context)
        fruit.name = name
        
        do {
            try context.save()
            return fruit
        } catch let err {
            print("Failed to create: \(err)")
        }
        
        return nil
    }
    

    func fetchFruit() -> [Fruit]? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Fruit>(entityName: "Fruit")

        do {
            let fruits = try context.fetch(fetchRequest)
            return fruits
        } catch let error {
            print("Failed to fetch fruits: \(error)")
        }

        return nil
    }
   
}
