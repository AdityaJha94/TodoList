//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Adi on 12/13/18.
//  Copyright © 2018 Aditya. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return categoryArray.count
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        //cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK:- Data Manipulation Method
    
    //CoreData Implementation
    
    /*
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error saving message**\(error)")
        }
        self.tableView.reloadData()
    }
 */
    //Realm Implementation
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving data**\(error)")
        }
        
    }
    
    
    //CoreData Implementation
    /*
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
            
        }catch{
            print("Error fetching from data**\(error)")
        }
        
        self.tableView.reloadData()
    }
 */
    
    //Realm Implementation
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    //MARK:- Adding category method
    
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        
        
        alert.addTextField{
            (alertTextField) in
            
            textField = alertTextField
            textField.placeholder = "Create category"
        }
        
        let action = UIAlertAction(title: "Add category", style: .default){ (action) in
            
            
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//
//            self.categoryArray.append(newCategory)
//            self.saveItems()
            
              let newCategory = Category()
              newCategory.name = textField.text!
              self.save(category: newCategory)
            
              self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
