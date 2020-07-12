# Diffable Data Sources

## Objective 

* To discuss the new declarative way of handling data sources in iOS. 
* Know how to configure a `UITableViewDiffableDataSource` type. 
* Understand `NSDiffableDataSourceSnapshot` and how to appy it to the data source. 
* Subclass `UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier>`. 
* Identify the benefits of using this new diffable data source way of dealing with table views or collection views. 


## Introducting Diffable Data Sources

For iOS 13 Apple introduced a new approach in handle data sources when it comes to setting up table views and collection views. This new approach aims to solve a varied amount of avoiding potential bugs in our code. Some of the potential bugs that could arise is due to the fact there are various states in which our data can be and different sources of truth of that data. With the introduction of diffable data sources there is one source of truth. This source of truth we will see throughout this lesson is the data **snapshot**. Once you adopt diffable data sources no longer will you encounter the following errro below: 

<pre> 
2020-07-11 22:01:50.650853-0400 UIDataSources[7989:2888089] *** Terminating app due to uncaught exception 
'NSInternalInconsistencyException', reason: 'Invalid update: invalid number of rows in section 0. The 
number of rows contained in an existing section after the update (15) must be equal to the number of rows
contained in that section before the update (15), plus or minus the number of rows inserted or deleted 
from that section (0 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that
section (0 moved in, 0 moved out).
</pre>


This is because since there in one source of truth the data source always has the most current state of our data. 

#### Declarative Approach 

With the introduction of SwiftUI, compostional layout and diffable data sources in iOS 13 Apple is moving away from the imperative approcah in programming and using declarative. In declarative programming you describe the how and the system decides the rest. 


## UITableViewDiffableDataSource 

Traditionally for our data source in a table view we implemented `cellForRow(at:)` and `numberOfRows(at:)` in order to setup the data for the table view or collection view. As we get new data for example from a web service API we needed to have a property observer on the main collection for the data soruce and then have a `reloadData` updating a table view. In this approach as stated earlier lead to different sources of truth for the data soruce. 

In `UITableViewDiffableDataSource` or `UICollectionViewDiffableDataSource` we set our data soruce which is one of these respective types and `apply()` the snapshot. With this approach we will now have only one source of truth which is the snapshot. We can then query this snapshot for any sort of modification on inquire we have about the data. 

## Setting up the UITableViewDiffableDataSource

`UITableViewDiffableDataSource` is a generic class that has two types: 

1. SectionIdentifier: representes the sections of the table view or collection view
2. ItemIdentifier: represents the items of a particular section 

#### Declare an instance of the data soruce 

```swift 
private var dataSource: UITableViewDiffableDataSource<Framework.Category, Framework>!
```
In the declaration above both types are required to conform to `Hashable` as this maintains uniqueness of the section values and item values of the sections. 

You need to subclass `UITableViewDiffableDataSource` if you'll be using other data source methods such at `titleForHeaderInSection`

```swift 
class DataSource: UITableViewDiffableDataSource<Framework.Category, Framework> {
  // protocol methods
}
```

We can now update our declaration for the `dataSource` instance to use our sublass. 

```swift 
private var dataSource: DataSource!
```


#### Configuring the data source instance

```swift 
dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, framework) -> UITableViewCell? in
  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  //let framework = frameworks[indexPath.section][indexPath.row]
  cell.textLabel?.text = framework.name
  return cell
})
```

`cellProvider` is a closure that has 3 arguments: a pointer to the tableView, indexPath of the current item and the item itself. This closure returns a `UITableViewCell`. The closure body is the place for cell configurations like done traditionally in the `cellForRow(at:)` method. In the cell provider we do not use the indexPath to find the item in question as we have a pointer to the item as one of the three arguments. 


## Setting up the snapshot 

As stated throughout this lesson the snapshot is the source of truth for our table view's data so let's go ahead and configure it. The basic steps for setting up a snapshot is as follows: 

1. Declare and instance of `NSDiffableDataSourceSnapshot` which needs to match the section and item type you specified for the data source. 
2. Append the required sections to the snapshot. 
3. Append the items for the section or each section if the table view or collection view has multiple sections. 
4. Add the default row animation to the data source. The default animation is `.automatic`.
5. Apply the snapshot to the data source. This step is the required step to update the current snapshot which will render items to the table view or collection view. 

```swift 
// 1 
var snapshot = NSDiffableDataSourceSnapshot<Framework.Category, Framework>()

for frameworks in Framework.getSections() {
  let category = frameworks.first?.cateogry ?? .system
  // 2 
  snapshot.appendSections([category])
  // 3 
  snapshot.appendItems(frameworks)
}

// 4
dataSource.apply(snapshot, animatingDifferences: true)
```



