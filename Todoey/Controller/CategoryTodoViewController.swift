//
//  CategoryTodoViewController.swift
//  Todoey
//
//  Created by Joshua Brown on 1/18/19.
//  Copyright © 2019 Evle Music. All rights reserved.
//

import UIKit
import CoreData

class CategoryTodoViewController: UITableViewController {
    
    var categoryArr = [ToDoCategory]()
    let containerContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArr[indexPath.row].name!
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArr[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func saveData(){
        do {
            try containerContext.save()
        } catch {
            print("error \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()){
        do{
            categoryArr = try containerContext.fetch(request)
        }catch{
            print("error, \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteCategory(delete category: NSManagedObject) {
        containerContext.delete(category)
        saveData()
        loadData()
    }
    
    //MARK: - Add Action Outlet
    
    @IBAction func AddCategory(_ sender: UIBarButtonItem) {
        var categoryName = UITextField()
        let alert = UIAlertController(title: "Add A New Todo Category", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Category", style: .default, handler: { (action) in
            let newCategory = ToDoCategory(context: self.containerContext)
            newCategory.name = categoryName.text!
            self.categoryArr.append(newCategory)
            self.saveData()
            self.tableView.reloadData()
        })
        alert.addTextField { (alertText) in
            alertText.placeholder = "Add a category"
            categoryName = alertText
        }
        
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    

}
