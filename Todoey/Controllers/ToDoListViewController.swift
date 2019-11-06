//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook on 9/10/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item] ()
    //Question mark means it is optional
    var selectedCategory : Category? {
        //didSet will be performed when categoty has a value
        didSet{
            loadItems()
        }
    }
    //           let dataFilePath  = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        searchBar.delegate = self
        // Mark - this path is the path of database inside device
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        print(dataFilePath)
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //        loadItems()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let item = itemArray[indexPath.row]
        //        itemArray[indexPath.row] .setValue("Completed", forKey: "title")
        //        itemArray[indexPath.row] .setValue(false, forKey: "done")
        //        item.done = !item.done
        
        
        //        context.delete(item)
        //        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todoey item", message:"" , preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add new item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            //            print(self.itemArray.count)
            
            self.saveItems()
            
        }
        
        
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Error Saving Context \(error)")
        }
        tableView.reloadData()
    }
    
    // predicate : NSPredicate? = nil means that this parameter is optional
    func  loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        request.predicate = predicate
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        
        // optional pindidng
        if let additionalPrediate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPrediate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do
        {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error while fetching items \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
}


//MARK: - SearchBar Methods
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //[cd] means case and diacratics insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with : request,predicate: request.predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            // we must call hiding keyboard function inside the dispatch queu to avoid screen freezing
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
}

