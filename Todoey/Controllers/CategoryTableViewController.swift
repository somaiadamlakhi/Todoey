//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MacBook on 10/28/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    
    
    //    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
    //    }
    //
    //Mark - Add new item
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new category", message:"" , preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "create new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add new category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            self.categoriesArray.append(newCategory)
            
            //            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            //            print(self.itemArray.count)
            
            self.saveItems()
            
        }
        
        
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
    }
    
    
    
    //MARK:- Tableview datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoriesArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    
    
    //MARK:- Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = self.categoriesArray[indexPath.row]
        }
        
    }
    //MARK:- Data manipulation method
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Error Saving Context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //[cd] means case and diacratics insensitive
//        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", seleca)
        do
        {
            categoriesArray = try context.fetch(request)
        }
        catch {
            print("Error while fetching categories \(error)")
        }
        
        tableView.reloadData()
    }
    
}
