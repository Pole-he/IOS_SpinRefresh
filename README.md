# IOS_SpinRefresh

PullRefresh and LoadMore with [SpinKit](https://github.com/raymondjavaxx/SpinKit-ObjC)  [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)

Easy to Integrate SpinRefresh in your project

## Screenshots

![push.gif](https://github.com/Pole-he/IOS_SpinRefresh/blob/master/Screenshots/push.gif)

## Properties

**Spinkit:**
```objective-c
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    } spin:RTSpinKitViewStyleBounce];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    } spin:RTSpinKitViewStyleBounce];
```
**Other:**
```objective-c
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    } bubbleRefresh:YES];
```


