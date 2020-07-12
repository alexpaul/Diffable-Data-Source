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

