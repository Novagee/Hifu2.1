//
//  HFBrowersTabBarController.m
//  HiFu
//
//  Created by Peng Wan on 10/12/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFBrowersTabBarController.h"
#import "HFMagicButton.h"
#import "HFRouteViewController.h"

@interface HFBrowersTabBarController ()

@property (strong, nonatomic) UIButton *magicButton;

@end

@implementation HFBrowersTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController NS_AVAILABLE_IOS(7_0){
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController NS_AVAILABLE_IOS(7_0){
    return UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - HFMagic Button Delegate

- (void)magicButtonTapped:(UIButton *)magicButton {
    
    HFRouteViewController *routeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"route"];

    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self presentViewController:routeViewController animated:NO completion:nil];
    
}

@end
