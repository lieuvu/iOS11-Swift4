//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Lieu Vu on 2/3/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    // MARK: SwipeTableViewCellDataSource
    // **********************************************************************
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: SwipeTableViewCellDelegate
    // **********************************************************************
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
            action, indexPath in
            
            self.updateModel(at: indexPath)
        }
        
        // customize the action apperance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    // MARK: Utilities
    // **********************************************************************
    
    /// Update data model at index path.
    ///
    /// - Note: This is an __abstract method__ and must be override by the
    /// inherited classes.
    ///
    /// - Parameters:
    ///     - indexPath: The index path.
    func updateModel(at indexPath: IndexPath) {
        // Update data model
    }
}
