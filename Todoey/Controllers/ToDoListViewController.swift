//
//  ViewController.swift
//  Todoey
//
//  Created by Timothy Head on 28/05/2019.
//  Copyright © 2019 Timothy Head. All rights reserved.
//

import UIKit
import CoreData

class ToDoLIstViewController: UITableViewController {
   
    
var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // print(dataFilePath)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
      
        
      
        
        
   //     if let items = defaults.array(forKey: "ToDoListArray1") as? [Item] {
    //   itemArray = items
   // }
    }
    //Mark:- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            print(alertTextField.text)
            textField = alertTextField
           
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
  //Mark - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoITemCell", for: indexPath)
        
        
     let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done  ? .checkmark : .none
        
       
        return cell
    }
    
    
    //Mark - tableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
 //       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
      
        
      
    }
    //Mark - Model Manipulation Methods
    
    func saveItems() {
      
        do {
         try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        } else {
            request.predicate = categoryPredicate
        }
       
        
      
 
    do {
  itemArray = try context.fetch(request)
    } catch {
        print("error fetching data from context \(error)")
    }
        tableView.reloadData()
    }
   
}
//Mark - Search bar methods
extension ToDoLIstViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        
        loadItems(with: request, predicate: predicate)
        
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
           
        }
        
    }
}
