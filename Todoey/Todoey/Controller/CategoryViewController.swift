//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lieu Vu on 2/3/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // MARK: Properties
    // **********************************************************************
    
    /// The array of item.
    private var categories: Results<Category>?
    
    /// The realm instance
    private let realm = try! Realm()
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: Actions
    // **********************************************************************
    
    /// Add button is pressed.
    ///
    /// - Parameters:
    ///     - sender: The add button.
    @IBAction private func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            // what will happen once the user clicks the Add Category button on
            // the UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColorStr = UIColor.randomFlat.hexValue()
            self.save(newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: UITableViewDataSource
    // **********************************************************************
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            print(category.hexColorStr)
            
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor.init(hexString: category.hexColorStr)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        } else {
            cell.textLabel?.text = Constant.defaultCategory
            cell.backgroundColor = UIColor.init(hexString: Constant.defaultHexColor)
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    // **********************************************************************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: Navigation
    // **********************************************************************
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: Delete Data From Swipe
    // **********************************************************************
    
    override func updateModel(at indexPath: IndexPath) {
        // GUARD: the category must exist.
        guard let category = self.categories?[indexPath.row] else {
            return
        }
        
        do {
            try self.realm.write {
                self.realm.delete(category)
            }
        } catch {
            print("Error deleting category, \(error)")
        }
    }
    
}

// MARK: - CategoryViewController (Utitlies)

extension CategoryViewController {

    /// Save categories
    ///
    /// - Parameters:
    ///     - category: The category to be saved in realm database.
    private func save(_ category: Category) {
        do {
            try realm.write() {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    /// Load categories.
    private func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}
