# ShoppingList app

In the Shopping app the user will be able view multiple sections of items and their categories. The user will be able to add a new item to a given section. The user will be able to remove an item for the shopping list. The user will also be able to reorder items. 

#### Part 1 - Multiple Sections

1. Create an Xcode project named **ShoppingList**. 
2. Define an `enum` called **Category** that will comprise of a series of item categories e.g running, technology, health. 
3. Create the main model for the ShoppingList app and name it **Item**. Item will have the following properties: 
    * name 
    * price
    * category
    * identifier
   Also Item will have to conform to the `Hashable` protocol in order to be an `ItemIdentifierType` on the `UITableViewDiffableDataSource`. We can also define 
   which property to be made the hashable value using the `func hash(into hasher:)` method. 
4. Subclass `UITableViewDiffableDataSource` so we are able to implement the necessary `UITableViewDataSource` methods we will need for the ShoppingList app. Some 
   of the protocol methods we will use include `func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)`. 
5. Configure the table view to take up the entire view's bounds. This can be done programmactically or via storyboard. 
6. Configure the data source using diffable data source.
7. Setup the initial snapshot and iterate through the **Category** cases to create the sections. Use `filter` to get all the relevant items for a given section as
   you iterate through the categories. The initial items for the sections will be fetched from a `func testData() -> [Item]` static method. 
8. Implement `func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)` to get the title for each of the sections. 
9. Complete app at the end of Part 1 should look like the following: 

   ![sections](https://github.com/alexpaul/Diffable-Data-Source/blob/master/Assets/shopping-list-sections.png)
   
#### Part 2 - Add an item to a given section

Challenge: 

```swift 
// Challenge
// TODO:
// 1. create a AddItemViewController.swift file
// 2. add a View Controller object in Storyboard
// 3. add 2 textfields, one for the item name and other for price
// 4. add a picker view to manage the categories
// 5. user is able to add a new item to a given category and click on a submit button
// 6. use any communication paradigm to get data from the AddItemViewController back to the ViewController
// types: (delegation, KVO, notification center, unwind segue, callback, combine)
```

#### Part 3 - Delete a given item 

#### Part 4 - Reorder itmes 
