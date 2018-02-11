//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Lieu Vu on 1/26/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    // MARK: Outlets
    // **********************************************************************
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: Properties
    // **********************************************************************
    
    /// The array of item.
    private var todoItems: Results<Item>?
    
    /// The realm instance.
    private let realm = try! Realm()
    
    /// The selected category
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHexCode = selectedCategory?.hexColorStr else {
                fatalError("Hex color string undefined")
        }
        
        title = selectedCategory?.name
        updateNavBar(withHexCode: colorHexCode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: Constant.defaultHexColor)
    }
    
    // MARK: UITableViewDataSource
    // **********************************************************************
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor.init(hexString: selectedCategory!.hexColorStr)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

    // MARK: UITableViewDelegate
    // **********************************************************************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // GUARD: the item must exist
        guard let item = todoItems?[indexPath.row] else {
            return
        }
        
        do {
            try realm.write {
                // realm.delete(item)
                item.done = !item.done
            }
        } catch {
            print("Error saving done status, \(error)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // MARK: Actions
    // **********************************************************************
    
    /// Press add button.
    ///
    /// - Parameters:
    ///     - sender: The add button.
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            // what will happen once the user clicks the Add Item button on
            // the UIAlert
            
            // GUARD: the selected category must exist
            guard let selectedCategory = self.selectedCategory else {
                return
            }
            
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    selectedCategory.items.append(newItem)
                }
                
            } catch {
                print("Error saving new items, \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Delete Data From Swipe
    // **********************************************************************
    
    override func updateModel(at indexPath: IndexPath) {
        // GUARD: item must exist
        guard let item = todoItems?[indexPath.row] else {
            return
        }
        
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error deleting item, \(item)")
        }
    }
}


// MARK: - TodoListViewController (Utilities)

extension TodoListViewController {
    
    /// Update the navigation bar with hex code.
    ///
    /// - Parameters:
    ///     - colorHexCode: The color hex code.
    private func updateNavBar(withHexCode colorHexCode: String) {
        let color = UIColor.init(hexString: colorHexCode)!
        
        navigationController?.navigationBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        navigationController?.navigationBar.barTintColor = color
        searchBar.barTintColor = color
    }
    
    /// Load item from the property list
    private func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}


// MARK: - TodoListViewController: UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if search bar is empty, load all items
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
