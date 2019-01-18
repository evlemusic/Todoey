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
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
            let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArr)
            try data.write(to: filePath!)
        } catch {
            print("error \(error)")
        }
    }

    func loadItems(){
        if let data = try? Data(contentsOf: filePath!){
            do{
                let decoder = PropertyListDecoder()
                let outArr = try decoder.decode([Item].self, from: data)
                itemArr = outArr
            }catch{
                print("error, \(error)")
            }
        }
    }
    
    func populateItemArr(){
        emptyItemArr()
        let item1 = Item()
        item1.title = "Kill Squirrels"
        itemArr.append(item1)
        let item2 = Item()
        item2.title = "Buy a new monkey"
        itemArr.append(item2)
        let item3 = Item()
        item3.title = "Kill all the godamn Junkies!"
        itemArr.append(item3)
        saveData()
    }
    
    func emptyItemArr(){
        loadItems()
        itemArr = [Item]()
        saveData()
    }
    
    
}
