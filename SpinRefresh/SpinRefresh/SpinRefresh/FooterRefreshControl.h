//
//  FooterRefreshControl.h
//  SpinRefresh
//
//  Created by Nathan_he on 15/7/27.
//  Copyright (c) 2015年 wangz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTSpinKitView.h"

#define deColor  [UIColor colorWithRed:240/255.0f green:124/255.0f blue:60/255.0f alpha:1.f]

typedef void (^BeginRefreshingBlock)(void);

@interface FooterRefreshControl : NSObject

@property(nonatomic,strong) UIScrollView *scrollView;

/**
 *  正在刷新的回调
 */
@property(nonatomic,copy) BeginRefreshingBlock beginRefreshingBlock;


@property (nonatomic, readonly) RTSpinKitView *spinner;

@property (nonatomic, assign) BOOL shouldChangeColorInstantly;

+ (instancetype)refreshControlWithStyle:(RTSpinKitViewStyle)style scrollview:(UIScrollView *)scrollview;

- (instancetype)initWithStyle:(RTSpinKitViewStyle)style
                        color:(UIColor *)color scrollview:(UIScrollView *)scrollview;
/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
-(void)beginRefreshing;

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
-(void)endRefreshing;


@end
