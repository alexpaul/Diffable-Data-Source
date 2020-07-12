# Diffable Data Sources

## Objective 

* To discuss the new declarative way of handling data sources in iOS. 
* Know how to configure a UITableViewDiffableDataSource type. 
* Identify the benefits of using this new diffable data source way of dealing with table views or collection views. 
* Understand what's a NSDiffableDataSourceSnapshot. 
* Subclass UITableViewDiffableDataSource. 


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

## Configuring the UITableViewDiffableDataSource

`UITableViewDiffableDataSource` is a generic class that has two types: 

1. SectionIdentifier: representes the sections of the table view or collection view
2. ItemIdentifier: represents the items of a particular section 

#### Declare an instacne of the data soruce 

```swift 
private var dataSource: UITableViewDiffableDataSource<Framework.Category, Framework>!
```

In the declaration above both types are required to conform to `Hashable` as this maintains uniqueness of the values. 


