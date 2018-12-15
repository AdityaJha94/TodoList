//
//  ViewController.swift
//  TodoList
//
//  Created by Adi on 12/2/18.
//  Copyright © 2018 Aditya. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListController: UITableViewController {
    
    var itemArray = [Item]()
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    var defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
//            itemArray = items
//        }
        
        //loadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Tableview DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return itemArray.count
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
//        let item = itemArray[indexPath.row]
//        cell.textLabel?.text = item.title
//
//        cell.accessoryType = item.done ? .checkmark : .none
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK:- Tableview Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error editing**\(error)")
            }
        }else{
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- IB Action
    
    @IBAction func addItemBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        
        
        alert.addTextField{
            (alertTextField) in
            
            textField = alertTextField
            textField.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            
            
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveItems()
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreatedAt = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving items**\(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK:- Model Maniplation Methods
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error saving message**\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //CoreData Implementation
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@ ", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
//        }
//
//
//        do{
//        itemArray = try context.fetch(request)
//
//        }catch{
//            print("Error fetching from data**\(error)")
//        }
//
//        self.tableView.reloadData()
//
//    }
    
    
    //Realm Implementation
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    
}

//MARK:- Search Bar Methods
extension ToDoListController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //CoreData Implementation
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
        
        //Realm Implementation
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreatedAt", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            self.loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

