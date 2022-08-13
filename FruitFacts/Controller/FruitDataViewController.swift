//
//  FruitDataViewController.swift
//  FruitFacts
//
//  Created by Ashley Smith on 8/2/22.
//

import UIKit

class FruitDataViewController: UIViewController {
    
    public var fruitName = String()
    var fruitManager = FruitManager()
 
//MARK: - UI Label Set Up
    
    lazy var fruitNameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 100)
        label.text = "\(fruitName)"
        return label
    }()
    
    lazy var fruitCaloriesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 150)
        return label
    }()
    
    lazy var fruitFatLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 200)
        return label
    }()
    
    lazy var fruitFamilyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 250)
        return label
    }()
    
    lazy var fruitProteinLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 300)
        return label
    }()
    
    lazy var fruitSugarLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 350)
        return label
    }()
    
    lazy var fruitCarbohydratesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 400)
        return label
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "fruitBackground"))
        image.frame = view.bounds
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.alpha = 0.4
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.addSubview(fruitNameLabel)
        view.addSubview(fruitCaloriesLabel)
        view.addSubview(fruitFatLabel)
        view.addSubview(fruitFamilyLabel)
        view.addSubview(fruitProteinLabel)
        view.addSubview(fruitSugarLabel)
        view.addSubview(fruitCarbohydratesLabel)
        fruitManager.delegate = self
        loadFruitInformation()
    }
    
 //MARK: - Load Data Function
    
    private func loadFruitInformation() {
        if let fruitName = fruitNameLabel.text {
            fruitManager.fetchData(fruitName: fruitName)
        }
    }
}

// MARK: - Fruit Manager Delegate

extension FruitDataViewController: FruitManagerDelegate {
    
    func didUpdateFruit(_fruitManager: FruitManager, fruit: ParsedFruitData) {
        DispatchQueue.main.async {
            self.fruitNameLabel.text = String(fruit.name)
            self.fruitCaloriesLabel.text = "Calories: \(fruit.calories)"
            self.fruitFatLabel.text = "Fat: \(fruit.fat)"
            self.fruitFamilyLabel.text = "Family: \(fruit.family)"
            self.fruitProteinLabel.text = "Protein: \(fruit.protein)"
            self.fruitSugarLabel.text = "Sugar: \(fruit.sugar)"
            self.fruitCarbohydratesLabel.text = "Carbohydrates: \(fruit.carbohydrates)"
        }
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
}
