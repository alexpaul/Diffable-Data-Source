## Countdown app

Let's build a countdown app using diffable data source. 

Our countdown app will start from 10 and decrement the initial value by 1 every second and add the new value as a row in the table view. Throughout the app we will make use of the **snapshot** as we update the table view and `apply` the changes. 

1. Create an Xcode project named **Countdown**.
2. Navigate to the ViewController.swift file and add the following: 
```swift 
enum Section {
  case main 
}

private var tableView: UITableView! 
private var dataSource: UITableViewDiffableDataSource<Section, Int>! 
private var timer: Timer! 
private var startInterval = 10 // seconds 
```
3. Configure the table view. 
4. Configure the data source. 
5. Configure the timer. 
6. Add the `startCountdown` method. 
7. Add the `decrementCounter` method.
8. Add the `ship` method. 
9. Add a `refresh` bar button item to restart countdown.

![countdown app](https://github.com/alexpaul/Diffable-Data-Source/blob/master/Assets/countdown-app.png)


[Back to main Lesson](https://github.com/alexpaul/Diffable-Data-Source)
