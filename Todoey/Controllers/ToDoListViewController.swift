//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook on 9/10/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item] ()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let item1 = Item()
        item1.title = "Somaia"
        item1.done = true
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "Razan"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "Suhaib"
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "ToDoItemCell") as? [Item]{
            itemArray = items
        }


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
    
        item.done = !item.done
    
        tableView.reloadData()
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
           let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            print(self.itemArray.count)
            self.tableView.reloadData()

        }
        
        
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
    }
}

