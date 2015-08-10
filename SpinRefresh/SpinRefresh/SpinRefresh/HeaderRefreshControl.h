//
//  HeaderRefreshControl.h
//  SpinRefresh
//
//  Created by Nathan_he on 15/7/27.
//  Copyright (c) 2015年 wangz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSpinKitView.h"

#define deColor  [UIColor colorWithRed:240/255.0f green:124/255.0f blue:60/255.0f alpha:1.f]

@protocol HeaderRefreshControlDelegate
<NSObject>

@optional

- (void)didShowRefreshControl;

- (void)didHideRefreshControl;

@end

@interface HeaderRefreshControl : UIRefreshControl

@property (nonatomic, weak) id <HeaderRefreshControlDelegate> delegate;

@property (nonatomic, readonly) RTSpinKitView *spinner;

@property (nonatomic, assign) BOOL shouldChangeColorInstantly;


#pragma mark Initialization

+ (instancetype)refreshControlWithStyle:(RTSpinKitViewStyle)style;

- (instancetype)initWithStyle:(RTSpinKitViewStyle)style
                        color:(UIColor *)color;

@end
