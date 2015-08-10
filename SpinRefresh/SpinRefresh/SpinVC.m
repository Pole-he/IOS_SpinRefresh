//
//  SpinVC.m
//  SpinRefresh
//
//  Created by Nathan_he on 15/8/10.
//  Copyright (c) 2015年 Nathan_he. All rights reserved.
//

#import "SpinVC.h"
#import "SVPullToRefresh.h"

@interface SpinVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSString *spin;
@property(nonatomic,strong) NSMutableArray *objects;
@end

@implementation SpinVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.objects = [NSMutableArray array];
        for(int i=0; i<15; i++)
        {
          [self.objects addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*90)]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak SpinVC *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    } spin:[self convertStrToRTSpinKitViewStyle:self.spin]];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    } spin:[self convertStrToRTSpinKitViewStyle:self.spin]];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView triggerPullToRefresh];
}

-(RTSpinKitViewStyle)convertStrToRTSpinKitViewStyle:(NSString *)spin
{
    if ([spin isEqualToString:@"RTSpinKitViewStylePlane"]) {
        return RTSpinKitViewStylePlane;
    }else if ([spin isEqualToString:@"RTSpinKitViewStyleCircleFlip"])
    {
        return RTSpinKitViewStyleCircleFlip;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleBounce"])
    {
        return RTSpinKitViewStyleBounce;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleWave"])
    {
        return RTSpinKitViewStyleWave;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleWanderingCubes"])
    {
        return RTSpinKitViewStyleWanderingCubes;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStylePulse"])
    {
        return RTSpinKitViewStylePulse;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleChasingDots"])
    {
        return RTSpinKitViewStyleChasingDots;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleThreeBounce"])
    {
        return RTSpinKitViewStyleThreeBounce;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleCircle"])
    {
        return RTSpinKitViewStyleCircle;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyle9CubeGrid"])
    {
        return RTSpinKitViewStyle9CubeGrid;
    }else if ([spin isEqualToString:@"RTSpinKitViewStyleWordPress"])
    {
        return RTSpinKitViewStyleWordPress;
    }else if ([spin isEqualToString:@"RTSpinKitViewStyleFadingCircle"])
    {
        return RTSpinKitViewStyleFadingCircle;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleFadingCircleAlt"])
    {
        return RTSpinKitViewStyleFadingCircleAlt;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleArc"])
    {
        return RTSpinKitViewStyleArc;
    }
    else if ([spin isEqualToString:@"RTSpinKitViewStyleArcAlt"])
    {
        return RTSpinKitViewStyleArcAlt;
    }
    return RTSpinKitViewStyleThreeBounce;
}


#pragma mark - Actions

- (void)insertRowAtTop {
    __weak SpinVC *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.objects insertObject:[NSDate date] atIndex:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtBottom {
    __weak SpinVC *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i ++) {
            [dataSource addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*90)]];
        }
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:dataSource.count];
        [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:weakSelf.objects.count + idx inSection:0]];
        }];
        [self.objects addObjectsFromArray:dataSource];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark Refresh Control
//- (void)refresh
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.refreshControl endRefreshing];
//    });
//}
//
//- (void)doubleRainbow
//{
//    CGFloat h, s, v, a;
//    [self.refreshControl.tintColor getHue:&h saturation:&s brightness:&v alpha:&a];
//
//    h = fmodf((h + 0.025f), 1.f);
//    self.refreshControl.tintColor = [UIColor colorWithHue:h saturation:s brightness:v alpha:a];
//}
//
//#pragma mark BDBSpinKitRefreshControl Delegate Methods
//- (void)didShowRefreshControl
//{
//    self.colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
//                                                       target:self
//                                                     selector:@selector(doubleRainbow)
//                                                     userInfo:nil
//                                                      repeats:YES];
//}
//
//- (void)didHideRefreshControl
//{
//    [self.colorTimer invalidate];
//}

#pragma mark UITableView Data Source / Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

    NSDate *date = [self.objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
