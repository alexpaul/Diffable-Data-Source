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

Challenge for the reader: 

```swift 
// Challenge: 
// TODO:
// 1. create a AddItemViewController.swift file
// 2. add a View Controller object in Storyboard
// 3. add 2 textfields, one for the item name and other for price
// 4. add a picker view to manage the categories
// 5. user is able to add a new item to a given category and click on a submit button
// 6. use any communication paradigm to get data from the AddItemViewController back to the ViewController
// types: (delegation, KVO, notification center, unwind segue, callback, combine)
```

1. After the above challenge is done the new item will be available to the **ItemFeedController**. 
2. If delegation was used the item will be available in the protocol method that the ItemFeedController needs to conform to. 
3. Get the current snapshot. 
4. Append the new item to the snapshot using `appendsItems(_, toSection: )` method. 
5. Apply the snapshot. 

#### Part 3 - Delete a given item 

Head to the **DataSource** class and implement the `func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath)` and `func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)`

1. Return to in the body of `func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath)`. 
2. In the `func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)` method perform the following: 
   1. Get the current snapshot. 
   2. Get the item using the `itemIdentifier(for: )` method of the data source. 
   3. Delete the items from the snapshot. 
   4. Apply the snapshot. 


#### Part 4 - Reorder itmes 

Reordering rows has a varied numbered of steps and is quite complex. There are four main scenarios at pictured below in order to achieve reordering.

Scenarios: 

1. Moving to the same index path. 
2. Moving the source item after the destination item. 
3. Moving the source item before the destination item. 
4. Moving the item to an index path that does yet exist. 

![reorder sketch](https://github.com/alexpaul/Diffable-Data-Source/blob/master/Assets/reorder-scenarios.jpg)

Head to the **DataSource** class and implement the `func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)` method and follow the steps below. 

1. Use a guard statement to get the source item using the source index path and `itemIdentifier(for: )` method. 
2. **Scenario 1**: Use a guard to check to make sure the item is not being moved to the same index path. 
3. Use `itemIdentifier(for: )` to get the destination item that will be replaced at the given destination index path. 
4. Get the current snapshot. 
5. **Scenario 2 and 3** Moving to an index path that exist. Here you want to make sure the destination item is not nil. 
    1. Use optional binding to get both the source index and the destination index. 
    2. Determine whether the source item should be inserted before or after the destination item. The is done by the resulting boolean value of determining if the        destination index is greater than the source index and the sections are the same. 
    3. Remove the source item from the snapshot before inserting the item at its new position. 
    4. **Scenario 2**: Moving the source item after the destination item. 
    5. **Scenario 3**: Moving the source item before the destination item. 
6. **Scenario 4**: Moving the item to an index path that does not yet exist. 
    1. Get the destination section identifier using `sectionIdentifiers` on the snapshot and accessing the destination index path's section. 
    2. Remove the source item from the snapshot before inserting the item at its new position.
    3. Append the item at its new section destination. 
7. Apply the snapshot. 

> As of this writing as per animatingDifference make sure to set it to false. Attempting to set it to true and animate as reordering happens will lead to an internal consistency crash. 

<details> 
  <summary>Full reording solution</summary> 
  
```swift 
override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
  // 1
  guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else {
    return
  }
  
  // 2
  guard sourceIndexPath != destinationIndexPath else {
    return
  }
  
  // 3
  let destinationIdentifier = itemIdentifier(for: destinationIndexPath)
  
  // 4
  var snapshot = self.snapshot()
  
  // 5
  if let destinationIdentifier = destinationIdentifier {
    // i
    if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
      let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
      // ii
      let isAfter = destinationIndex > sourceIndex &&
        snapshot.sectionIdentifier(containingItem: sourceIdentifier) == snapshot.sectionIdentifier(containingItem: destinationIdentifier)
      
      // iii
      snapshot.deleteItems([sourceIdentifier])
      
      // iv
      if isAfter {
        snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
      }
      
      // v
      else {
        snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
      }
    }
  }
  
  // 6
  else {
    // i
    let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
    
    // ii
    snapshot.deleteItems([sourceIdentifier])
    
    // iii
    snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
  }
  
  // 7
  apply(snapshot, animatingDifferences: false)
}
```
  
</details> 
