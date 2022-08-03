//
//  FruitViewController.swift
//  FruitFacts
//
//  Created by Ashley Smith on 6/27/22.
//

import UIKit
import CoreData

class FruitViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fruit = [Fruit]()
    var safeArea: UILayoutGuide!
    let tableView = UITableView()
    var button = UIButton()
    var fruitManager = FruitManager()
    
    private var titleLabel: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.text = "Fruit Facts"
        label.center = CGPoint(x: 210, y: 65)
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        addButton()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "fruitCell")
        tableView.dataSource = self
        tableView.delegate = self
        let image = UIImageView(image: UIImage(named: "fruitBackground"))
        tableView.backgroundView = image
            image.contentMode = UIView.ContentMode.scaleAspectFill
            image.alpha = 0.4
        tableView.rowHeight = 80.0
        
        
        loadFruit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
      }
    
    func addButton() {
        button = UIButton(configuration: .filled())
        button.tintColor = UIColor(red: 0.62, green: 0.70, blue: 0.95, alpha: 1.00)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 340, y: 50, width: 50, height: 50)
        button.configuration?.title = "+"
        view.addSubview(button)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Fruit", message: "", preferredStyle: .alert)
            let addAction = UIAlertAction(title: "Add Fruit", style: .default) { (action) in
                if let entry = textField.text {
                    let newFruit = Fruit(context: self.context)
                    newFruit.name = entry
                    self.fruit.append(newFruit)
                    self.saveFruit()
                }
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Enter New Fruit"
                textField = alertTextField
            }
            
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveFruit(){
        do {
            try context.save()
            
        } catch {
            print("Error saving new fruit, \(error).")
        }
        tableView.reloadData()
    }

    func loadFruit(){
        let request : NSFetchRequest<Fruit> = Fruit.fetchRequest()
        do {
            fruit = try context.fetch(request)
           
        } catch {
            print("Error loading recipe data, \(error).")
        }
        
        tableView.reloadData()
    }
}



//MARK: Table View Data Source
extension FruitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fruitCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = fruit[indexPath.row].name
        return cell
        
    }
}

//MARK: Table View Delegate

extension FruitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fruit = fruit[indexPath.row].name
        fruitManager.fetchData(fruitName: fruit!)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToFruitDataVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let destinationVC = segue.destination as! FruitDataViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.fruitName = fruit[indexPath.row].name ?? "No fruit found."
            }
        }
    }


