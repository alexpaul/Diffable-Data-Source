//
//  DataSource.swift
//  ShoppingList
//
//  Created by Alex Paul on 7/15/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

// conforms to UITableViewDataSource
class DataSource: UITableViewDiffableDataSource<Category, Item> {
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if Category.allCases[section] == .shoppingCart {
      return "🛒" + Category.allCases[section].rawValue
    } else {
      return Category.allCases[section].rawValue // "Running"
    }
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // 1. get the current snapshot
      var snapshot = self.snapshot()
      // 2. get the item using the itemIdentifier
      if let item = itemIdentifier(for: indexPath) {
        // 3. delete the item from the snapshot
        snapshot.deleteItems([item])
        // 4. apply the snapshot (apply changes to the datasource which in turn updates the table view)
        apply(snapshot, animatingDifferences: true)
      }
    }
  }
  
  // 1. reordering steps
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // 2. reordering steps
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    // get the source item
    guard let sourceItem = itemIdentifier(for: sourceIndexPath) else { return }
    
    // SCENARIO 1: attempting to move to self
    guard sourceIndexPath != destinationIndexPath else {
      // if the source and destination are the same
      print("move to self")
      return
    }
    
    // get the destination item
    let destinationItem = itemIdentifier(for: destinationIndexPath)
    
    // get the current snapshot
    var snapshot = self.snapshot()
    
    // handle SCENARIO 2 AND 3
    if let destinationItem = destinationItem {
      
      // get the source index and the destination index
      if let sourceIndex = snapshot.indexOfItem(sourceItem),
        let destinationIndex = snapshot.indexOfItem(destinationItem) {
        
        // what order should we be inserting the source item
        let isAfter = destinationIndex > sourceIndex
          && snapshot.sectionIdentifier(containingItem: sourceItem) ==
        snapshot.sectionIdentifier(containingItem: destinationItem)
        
        // first delete the source item from the snapshot
        snapshot.deleteItems([sourceItem])
        
        // SCENARIO 2
        if isAfter {
          print("after destination")
          snapshot.insertItems([sourceItem], afterItem: destinationItem)
        }
        
        // SCENARIO 3
        else {
          print("before destination")
          snapshot.insertItems([sourceItem], beforeItem: destinationItem)
        }
      }
      
    }
    
    // handle SCENARIO 4
    // no index path at destination section
    else {
      print("new index path")
      // get the section for the destination index path
      let destinationSection = snapshot.sectionIdentifiers[destinationIndexPath.section]
      
      // delete the source item before reinserting it
      snapshot.deleteItems([sourceItem])
      
      // append the source item at the new section
      snapshot.appendItems([sourceItem], toSection: destinationSection)
    }
    
    // apply changes to the data souce
    apply(snapshot, animatingDifferences: false)
  }

  
}
