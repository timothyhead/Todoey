//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Timothy Head on 12/06/2019.
//  Copyright © 2019 Timothy Head. All rights reserved.
//

import UIKit
import  CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
    }
    
    
    
    
    //Mark: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen when user clicks the add category button on our UIAlert
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            self.saveCategory()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new catergory"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        let category = categoryArray[indexPath.row]
        cell?.textLabel?.text = category.name
        
        return cell!
    }
    //Mark: - TableView Delgate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoLIstViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
          categoryArray = try context.fetch(request)
        } catch  {
            print("error fetching data from \(error)")
        }
        tableView.reloadData()
    }
}
