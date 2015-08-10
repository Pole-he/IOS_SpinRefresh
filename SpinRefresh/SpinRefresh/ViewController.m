//
//  ViewController.m
//  SpinRefresh
//
//  Created by Nathan_he on 15/8/8.
//  Copyright (c) 2015年 Nathan_he. All rights reserved.
//

#import "ViewController.h"
#define SpinArr [NSArray arrayWithObjects:@"RTSpinKitViewStylePlane",@"RTSpinKitViewStyleCircleFlip",@"RTSpinKitViewStyleBounce",@"RTSpinKitViewStyleWave",@"RTSpinKitViewStyleWanderingCubes",@"RTSpinKitViewStylePulse",@"RTSpinKitViewStyleChasingDots",@"RTSpinKitViewStyleThreeBounce",@"RTSpinKitViewStyleCircle",@"RTSpinKitViewStyle9CubeGrid",@"RTSpinKitViewStyleWordPress",@"RTSpinKitViewStyleFadingCircle",@"RTSpinKitViewStyleFadingCircleAlt",@"RTSpinKitViewStyleArc",@"RTSpinKitViewStyleArcAlt", nil]

@interface ViewController ()

@property(nonatomic,strong) UIAlertController *actionController;
@property(nonatomic,strong) NSString *spin;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showSpinsAction:(id)sender {
    if (!self.actionController) {
        self.actionController = [UIAlertController alertControllerWithTitle:@"SPIN" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        for (NSString *spin in SpinArr) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:spin style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                self.spin = spin;
                [self performSegueWithIdentifier:@"spinPush" sender:self];
            }];
            [self.actionController addAction:otherAction];
        }
        
        // Add the actions.
        [self.actionController addAction:cancelAction];
    }
    [self presentViewController:self.actionController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc respondsToSelector:@selector(setSpin:)]) {
        [vc setValue:self.spin forKey:@"spin"];
    }
}



@end
