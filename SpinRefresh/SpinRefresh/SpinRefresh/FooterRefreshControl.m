//
//  FooterRefreshControl.m
//  SpinRefresh
//
//  Created by Nathan_he on 15/7/27.
//  Copyright (c) 2015年 wangz. All rights reserved.
//

#import "FooterRefreshControl.h"

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface FooterRefreshControl (){
    
    
    float contentHeight;
    float scrollFrameHeight;
    float footerHeight;
    float scrollWidth;
    BOOL isAdd;//是否添加了footer,默认是NO
    BOOL isRefresh;//是否正在刷新,默认是NO
    BOOL isReady;//是否正在刷新,默认是NO
    UIView *footerView;
    
}
@property (nonatomic) UIColor *color;

@end

@implementation FooterRefreshControl

+ (instancetype)refreshControlWithStyle:(RTSpinKitViewStyle)style scrollview:(UIScrollView *)scrollview
{
    return [[[self class] alloc] initWithStyle:style color:deColor scrollview:scrollview];
}

- (instancetype)initWithStyle:(RTSpinKitViewStyle)style
                        color:(UIColor *)color scrollview:(UIScrollView *)scrollview
{
    self = [super init];
    
    if (self) {
        
        _scrollView = scrollview;
        
        scrollWidth=_scrollView.frame.size.width;
        footerHeight=50;
        scrollFrameHeight=_scrollView.frame.size.height;
        isAdd=NO;
        isRefresh=NO;
        
        footerView=[[UIView alloc] init];
        
        _spinner = [[RTSpinKitView alloc] initWithStyle:style color:color];
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        _color = color;
        _shouldChangeColorInstantly = false;
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    contentHeight=_scrollView.contentSize.height<80?ScreenHeight:_scrollView.contentSize.height;
    
    
    if (!isAdd) {
        isAdd=YES;
        
        
        footerView.frame=CGRectMake(0, contentHeight, ScreenWidth, footerHeight);
        [_scrollView addSubview:footerView];
        
        
        _spinner.center = CGPointMake(footerView.bounds.size.width/2, footerView.bounds.size.height/2);
        [footerView addSubview:_spinner];
    }
    
//    footerView.frame=CGRectMake(0, contentHeight, ScreenWidth, footerHeight);
//    _spinner.center = CGPointMake(footerView.bounds.size.width/2, footerView.bounds.size.height/2);
    
    int currentPostion = _scrollView.contentOffset.y;
    NSLog(@"%d",currentPostion);
    // 进入刷新状态
    if ((currentPostion-(contentHeight-scrollFrameHeight)>=10)&&(contentHeight>scrollFrameHeight) && _scrollView.contentInset.bottom==0) {
        isReady = YES;
        [self.spinner startAnimating];
    }else if(currentPostion-(contentHeight-scrollFrameHeight)<10 && isReady)
    {
        [self beginRefreshing];
        isReady = NO;
    }
    
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing{
    if (!isRefresh) {
        isRefresh=YES;
        // [self.spinner startAnimating];
        //        设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, footerHeight, 0);
            
        } completion:^(BOOL finished) {
            
            //        block回调
            _beginRefreshingBlock();
        }];
        
        
    }
    
}

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
- (void)endRefreshing{
    isRefresh=NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
             [self.spinner stopAnimating];
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);

            footerView.frame=CGRectMake(0, contentHeight, ScreenWidth, footerHeight);
        }];
    });
}

- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
}


@end
