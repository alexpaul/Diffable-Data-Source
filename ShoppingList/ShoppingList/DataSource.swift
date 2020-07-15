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
  
}
