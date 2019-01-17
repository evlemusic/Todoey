//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Brown on 1/17/19.
//  Copyright © 2019 Evle Music. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArr = ["Kill Squirels", "Buy New Monkey", "Find the Godamn Junkies"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoArr") as? [String] {
            itemArr = items
        }
    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArr[indexPath.row]
        return cell
    }
    
    //MARK: Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - create addTodo
    
    
    @IBAction func AddTodo(_ sender: UIBarButtonItem) {
        var todoToAdd = UITextField()
        
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            self.itemArr.append(todoToAdd.text!)
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
