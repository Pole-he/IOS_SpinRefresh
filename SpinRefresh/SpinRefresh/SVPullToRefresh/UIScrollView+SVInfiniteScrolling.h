//
// UIScrollView+SVInfiniteScrolling.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import "SCBubbleRefreshView.h"
#import "NaRTSpinKitView.h"

@class SVInfiniteScrollingView;

@interface UIScrollView (SVInfiniteScrolling)
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler bubbleRefresh:(BOOL) isBubbled;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler spin:(RTSpinKitViewStyle)style;

- (void)triggerInfiniteScrolling;

@property (nonatomic, strong, readonly) SVInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@end


enum {
	SVInfiniteScrollingStateStopped = 0,
    SVInfiniteScrollingStateTriggered,
    SVInfiniteScrollingStateLoading,
    SVInfiniteScrollingStateAll = 10
};

typedef NSUInteger SVInfiniteScrollingState;

@interface SVInfiniteScrollingView : UIView

@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, readwrite) SCBubbleRefreshView *refreshView;
@property (nonatomic, readonly) SVInfiniteScrollingState state;
@property (nonatomic, strong) NaRTSpinKitView *spinView;

@property (nonatomic, readwrite) BOOL enabled;
@property (nonatomic) BOOL isBubbleRefresh;
@property (nonatomic) BOOL isSpinRefresh;

- (void)setCustomView:(UIView *)view forState:(SVInfiniteScrollingState)state;
- (id)initWithBubbledFrame:(CGRect)frame ;
- (id)initWithFrame:(CGRect)frame style:(RTSpinKitViewStyle)style;

- (void)startAnimating;
- (void)stopAnimating;

@end
