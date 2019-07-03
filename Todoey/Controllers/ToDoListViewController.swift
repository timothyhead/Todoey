//
//  ViewController.swift
//  Todoey
//
//  Created by Timothy Head on 28/05/2019.
//  Copyright © 2019 Timothy Head. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoLIstViewController: UITableViewController {
   
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
  
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
            
            if let currentCategory = self.selectedCategory {
           
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                    newItem.dateCreated = Date()
                }
            } catch  {
                print("Error saving context \(error)")
            }
            }
        
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            print(alertTextField.text!)
            textField = alertTextField
           
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
  //Mark - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoITemCell", for: indexPath)
        
        
        if let item = toDoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done  ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    
    //Mark - tableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if let item = toDoItems?[indexPath.row] {
            do {
               try realm.write {
    //    realm.delete(item)
                   item.done = !item.done
                }
                } catch {
                    print("Error saving done status, \(error)")
                }
            }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    //Mark - Model Manipulation Methods
    
/*
*/
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
  /*      let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
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
*/
    }
    
}
//Mark - Search bar methods
extension ToDoLIstViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
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

