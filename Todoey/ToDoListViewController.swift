//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook on 9/10/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Omar","Bashar","Fatima","Ahmed","Khansa","Asma","Adnan","Somaia","Abdullah"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark    ){
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
            self.itemArray.append(textField.text!)
            
            print(self.itemArray.count)
            self.tableView.reloadData()

        }
        
        
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
    }
}

