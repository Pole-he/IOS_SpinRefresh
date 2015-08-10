//
//  NaRTSpinKitView.m
//  SpinRefresh
//
//  Created by Nathan_he on 15/8/10.
//  Copyright (c) 2015年 Nathan_he. All rights reserved.
//

#import "NaRTSpinKitView.h"

#define deColor  [UIColor colorWithRed:240/255.0f green:124/255.0f blue:60/255.0f alpha:1.f]

@interface NaRTSpinKitView()

@property (nonatomic) NSTimer *colorTimer;

@end

@implementation NaRTSpinKitView

-(instancetype)initWithStyle:(RTSpinKitViewStyle)style {
    self.shouldChangeColorInstantly = YES;
    return [super initWithStyle:style color:deColor];
}


-(void)startAnimating
{
    [super startAnimating];
    if (self.shouldChangeColorInstantly) {
        self.colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                           target:self
                                                         selector:@selector(doubleRainbow)
                                                         userInfo:nil
                                                          repeats:YES];
    }
}

-(void)stopAnimating
{
    [super stopAnimating];
    if (self.shouldChangeColorInstantly) {
    [self.colorTimer invalidate];
    }
}

- (void)doubleRainbow
{
    CGFloat h, s, v, a;
    [self.color getHue:&h saturation:&s brightness:&v alpha:&a];
    
    h = fmodf((h + 0.025f), 1.f);
    [self setColor:[UIColor colorWithHue:h saturation:s brightness:v alpha:a]];
}


@end
