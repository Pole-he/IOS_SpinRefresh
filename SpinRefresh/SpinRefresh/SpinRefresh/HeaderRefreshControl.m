//
//  HeaderRefreshControl.m
//  SpinRefresh
//
//  Created by Nathan_he on 15/7/27.
//  Copyright (c) 2015年 wangz. All rights reserved.
//

#import "HeaderRefreshControl.h"

static void * const NaSpinKitRefreshControlKVOContext = (void *)&NaSpinKitRefreshControlKVOContext;

static NSString * const kKVOKeyPathHidden = @"hidden";

@interface HeaderRefreshControl ()

@property (nonatomic) UIColor *color;

@end

@implementation HeaderRefreshControl

#pragma mark Initialization
+ (instancetype)refreshControlWithStyle:(RTSpinKitViewStyle)style
{
    return [[[self class] alloc] initWithStyle:style color:deColor];
}

- (instancetype)initWithStyle:(RTSpinKitViewStyle)style
                        color:(UIColor *)color
{
    self = [super init];
    
    if (self) {
        super.tintColor = [UIColor clearColor];
        
        _spinner = [[RTSpinKitView alloc] initWithStyle:style color:color];
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        _color = color;
        _shouldChangeColorInstantly = false;
        
        
        UIView *modernContentView = self.subviews.lastObject;
        UIView *containerView = modernContentView.subviews.firstObject;
        
        if (containerView) {
            [containerView removeFromSuperview];
        }
        
        [modernContentView addSubview:self.spinner];
        self.spinner.center = modernContentView.center;
        
        [super addObserver:self
                forKeyPath:kKVOKeyPathHidden
                   options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                   context:NaSpinKitRefreshControlKVOContext];
    }
    
    return self;
}

- (void)dealloc
{
    @try {
        [super removeObserver:self
                   forKeyPath:kKVOKeyPathHidden
                      context:NaSpinKitRefreshControlKVOContext];
    }
    @catch (NSException * __unused exception) {
        // Ignore
    }
}

#pragma mark View Lifecycle
//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    [super willMoveToSuperview:newSuperview];
//    
//    [self.spinner removeFromSuperview];
//}
//
//- (void)didMoveToSuperview
//{
//    [super didMoveToSuperview];
//    
//    UIView *modernContentView = self.subviews.lastObject;
//    UIView *containerView = modernContentView.subviews.firstObject;
//    
//    if (containerView) {
//        [containerView removeFromSuperview];
//    }
//    
//    [modernContentView addSubview:self.spinner];
//    self.spinner.center = modernContentView.center;
//}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == NaSpinKitRefreshControlKVOContext) {
        if ([object isKindOfClass:[self class]]) {
            if ([keyPath isEqualToString:kKVOKeyPathHidden]) {
                BOOL isHidden = [change[NSKeyValueChangeOldKey] boolValue];
                BOOL willHide = [change[NSKeyValueChangeNewKey] boolValue];
                
                if (isHidden && !willHide) {
                    self.spinner.color = self.color;
                    [self.spinner startAnimating];
                    
                    if ([self.delegate respondsToSelector:@selector(didShowRefreshControl)]) {
                        [self.delegate didShowRefreshControl];
                    }
                } else if (!isHidden && willHide) {
                    [self.spinner stopAnimating];
                    
                    if ([self.delegate respondsToSelector:@selector(didHideRefreshControl)]) {
                        [self.delegate didHideRefreshControl];
                    }
                }
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

-(void)beginRefreshing
{
    [((UIScrollView *)self.superview) setContentOffset:CGPointMake(0, -self.frame.size.height) animated:YES];
    [super beginRefreshing];

//    // Only do this specific "hack" if super view is a collection view
//    if ([[self superview] isKindOfClass:[UICollectionView class]]) {
//        UICollectionView *superCollectionView = (UICollectionView *)[self superview];
//        
//        // If the user did change the content offset we do not want to animate a new one
//        if (CGPointEqualToPoint([superCollectionView contentOffset], CGPointZero)) {
//            
//            // Set the new content offset based on UIRefreshControl height
//            [superCollectionView setContentOffset:CGPointMake(0, -CGRectGetHeight([self frame])) animated:YES];
//            
//            // Call super after the animation is finished, all apple animations is .3 sec
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (0.3 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [super beginRefreshing];
//            });
//        } else {
//            [super beginRefreshing];
//        }
//    } else {
//        
//        [super beginRefreshing];
//    }
}

-(void)endRefreshing
{
    [((UIScrollView *)self.superview) setContentOffset:CGPointMake(0, 0) animated:YES];
    [super endRefreshing];
}

#pragma mark Overridden Properties
- (void)setTintColor:(UIColor *)color
{
    _color = color;
    
    if (self.shouldChangeColorInstantly || self.spinner.hidden) {
        self.spinner.color = color;
    }
}

- (UIColor *)tintColor
{
    return self.color;
}

@end
