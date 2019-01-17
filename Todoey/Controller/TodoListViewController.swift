//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Brown on 1/17/19.
//  Copyright © 2019 Evle Music. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArr = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Item()
        item1.title = "Kill Squirels"
        itemArr.append(item1)
        
        let item2 = Item()
        item2.title = "Buy New Monkey"
        itemArr.append(item2)
        
        let item3 = Item()
        item3.title = "Find the Godamn Junkies"
        itemArr.append(item3)
        
        
        if let items = defaults.array(forKey: "TodoArr") as? [Item] {
            itemArr = items
        }
    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArr[indexPath.row].title
        return cell
    }
    
    //MARK: Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedItem = itemArr[indexPath.row]
        tappedItem.done = !tappedItem.done
        tableView.cellForRow(at: indexPath)?.accessoryType = tappedItem.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - create addTodo
    
    
    @IBAction func AddTodo(_ sender: UIBarButtonItem) {
        var todoToAdd = UITextField()
        
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            let newItem = Item()
            newItem.title = todoToAdd.text!
            self.itemArr.append(newItem)
            self.defaults.set(self.itemArr, forKey: "TodoArr")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            todoToAdd = alertTextField
        }
        
        
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    }
}
