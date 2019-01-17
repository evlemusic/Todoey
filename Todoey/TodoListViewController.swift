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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print(indexPath.row)
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    
    
}

