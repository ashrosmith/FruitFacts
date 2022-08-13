//
//  FruitViewController.swift
//  FruitFacts
//
//  Created by Ashley Smith on 6/27/22.
//

import UIKit
import CoreData

class FruitViewController: UIViewController {

    var fetchedResultsController: NSFetchedResultsController<Fruit>!
  
    let context = CoreDataManager.shared.persistentContainer.viewContext
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
 
 //MARK: - Button Functions
    
    func addButton() {
        button = UIButton(configuration: .filled())
        button.tintColor = UIColor(red: 0.62, green: 0.70, blue: 0.95, alpha: 1.00)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 340, y: 50, width: 50, height: 50)
        button.configuration?.title = "+"
        view.addSubview(button)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Fruit", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Fruit", style: .default) { (action) in
            if let entry = textField.text {
                CoreDataManager.shared.createFruit(name: entry)
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
    
 //MARK: - Load Fruit Method

    func loadFruit(){
        if fetchedResultsController == nil {
            let request = NSFetchRequest<Fruit>(entityName: "Fruit")
            let sort = NSSortDescriptor(key: "name", ascending: false)
                        request.sortDescriptors = [sort]
                        request.fetchBatchSize = 20
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
}

//MARK: - UITableView Data Source

extension FruitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fruitCell", for: indexPath)
        let fruit = fetchedResultsController.object(at: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = fruit.name
        return cell
        
    }
}

//MARK: - UITableView Delegate

extension FruitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToFruitDataVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let destinationVC = segue.destination as! FruitDataViewController
      if let indexPath = tableView.indexPathForSelectedRow {
          let fruit = fetchedResultsController.object(at: indexPath)
            destinationVC.fruitName = fruit.name ?? "No fruit found."
            }
        }
 
}

//MARK: - NSFetchedResults Delegate
extension FruitViewController: NSFetchedResultsControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates() // a
    }
          
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade) // b
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates() // c
    }
}
