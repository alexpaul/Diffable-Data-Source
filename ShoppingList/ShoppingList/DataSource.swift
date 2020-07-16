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
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      var snapshot = self.snapshot()
      if let item = itemIdentifier(for: indexPath) {
        snapshot.deleteItems([item])
        apply(snapshot, animatingDifferences: true)
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    // 4 scenarios
    /*
     1. moving to the same index path
     2. after destination
     3. before destination
     4. new index path
    */
    
    // 1
    // get the source item using the source index path
    guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else {
      return
    }

    // 2
    // SCENARIO #1 where user is trying to move an item to the same index path
    guard sourceIndexPath != destinationIndexPath else {
      return
    }

    // 3
    // get the item that that will be replaced at the given destination index path
    let destinationIdentifier = itemIdentifier(for: destinationIndexPath)

    // 4
    // get the current snapshot
    var snapshot = self.snapshot()

    // 5
    // moving to an index path that exist
    if let destinationIdentifier = destinationIdentifier {
      // a
      // get the source index and the destination index
      if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
        let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {

        // b
        // determine whether the source item should be inserted before or after the destination item
        let isAfter = destinationIndex > sourceIndex &&
          snapshot.sectionIdentifier(containingItem: sourceIdentifier) == snapshot.sectionIdentifier(containingItem: destinationIdentifier)

        // c
        // remove the source item from the snapshot before inserting at new position
        snapshot.deleteItems([sourceIdentifier])

        // d
        // SCENARIO #2 moving source after destination
        if isAfter {
          print("after destination")
          snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
        }
        
        // SCENARIO #3 moving source before destination
        else {
          print("before destination")
          snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
        }
      }
    }

    // 6
    // SCENARIO #4 moving to an index path that does yet exist
    else {
      print("new index path")
      // a
      // get the destination section identifier
      let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]

      // b
      // remove the source item from the snapshot before inserting at new position
      snapshot.deleteItems([sourceIdentifier])

      // c
      // append the item at it's new destination
      snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
    }

    // 7
    // apply the snapshot
    apply(snapshot, animatingDifferences: false)
    // WARNING CRASHES APP IF ANIMATE IS SET TO TRUE, WHY???????
  }
}
