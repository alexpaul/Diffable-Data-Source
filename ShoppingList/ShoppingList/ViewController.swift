//
//  ViewController.swift
//  ShoppingList
//
//  Created by Alex Paul on 7/15/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private var tableView: UITableView!
  private var dataSource: DataSource! // is the subclass we created

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavBar()
    configureTableView()
    configureDataSource()
  }
  
  private func configureNavBar() {
    navigationItem.title = "Shopping List"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditState))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddVC))
  }
  
  private func configureTableView() {
    tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.backgroundColor = .systemGroupedBackground
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    view.addSubview(tableView)
  }
  
  private func configureDataSource() {
    dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = "\(item.name)"
      return cell
    })
    
    // setup type of animation
    dataSource.defaultRowAnimation = .fade
    
    // setup initial snapshot
    var snapshot = NSDiffableDataSourceSnapshot<Category, Item>()
    
    // populate snapshot with sections and items for each section
    // CaseIterable allows us to iterate through all the cases of an enum
    for category in Category.allCases { // all cases from the Category enum
      // filter the testData() [items] for that particular category's items
      let items = Item.testData().filter { $0.category == category }
      snapshot.appendSections([category]) // add section to table view
      snapshot.appendItems(items)
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  @objc private func toggleEditState() {
    
  }
  
  @objc private func presentAddVC() {
    // TODO:
    // 1. create a AddItemViewController.swift file
    // 2. add a View Controller object in Storyboard
    // 3. add 2 textfields, one for the item name and other for price
    // 4. add a picker view to manage the categories
    // 5. user is able to add a new item to a given category and click on a submit button
    // 6. use any communication paradigm to get data from the AddItemViewController back to the ViewController
    // types: (delegation, KVO, notification center, unwind segue, callback, combine)
  }
  

}

/*
extension ViewController: AddItemViewControllerDelegate {
  func didAddItem(item: Item) {
    var snapshot = dataSource.snapshot()
    snapshot.appendItems([item], toSection: item.category)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}
*/

