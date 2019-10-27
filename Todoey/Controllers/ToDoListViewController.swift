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
    
           let dataFilePath  = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
 
        print(dataFilePath)
        
    
        loadItems()
        
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
           let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
//            self.defaults.set(self.itemArray, forKey: "toDoListArray")
//            print(self.itemArray.count)
            
            self.saveItems()

        }
        
        
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
            
        }
        catch{
            print("Error encoding item array /\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!)  {
            let decoder = PropertyListDecoder()
            
            do{
            try itemArray = decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding items array \(error)")
            }
        }
    }
}

