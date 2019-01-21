//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Brown on 1/17/19.
//  Copyright © 2019 Evle Music. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArr = [Item]()
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let containerContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : ToDoCategory? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArr[indexPath.row].title
        cell.accessoryType = itemArr[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK: Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedItem = itemArr[indexPath.row]
        tappedItem.done = !tappedItem.done
        self.saveData()
//        self.removeItem(index: indexPath.row)
//        self.tableView.reloadData()
        tableView.cellForRow(at: indexPath)?.accessoryType = tappedItem.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - create addTodo
    
    
    @IBAction func AddTodo(_ sender: UIBarButtonItem) {
        var todoToAdd = UITextField()
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            let newItem = Item(context: self.containerContext)
            newItem.title = todoToAdd.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArr.append(newItem)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            todoToAdd = alertTextField
        }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
        do {
            try containerContext.save()
        } catch {
            print("error \(error)")
        }
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let subPred = predicate {
            let comboPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, subPred])
            request.predicate = comboPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do{
            itemArr = try containerContext.fetch(request)
        }catch{
            print("error, \(error)")
        }
        tableView.reloadData()
    }
    
    func removeItem(index: Int){
        containerContext.delete(itemArr[index])
        itemArr.remove(at: index)
        saveData()
    }
    
}

//MARK: - search extension
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
