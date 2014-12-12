//
//  HFDiscountFinalViewController.m
//  HiFu
//
//  Created by Peng Wan on 11/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFDiscountFinalViewController.h"
#import <Appsee/Appsee.h>

@implementation HFDiscountFinalViewController

- (void)viewDidLoad {
    
    // Navigation Item
    //
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.title = @"无法使用优惠劵的原因";
    
}

- (void)viewDidLayoutSubviews {
    
    _option_A.imageView.hidden = NO;
    _option_B.imageView.hidden = YES;
    _option_C.imageView.hidden = YES;
    
}

- (void)leftBarButtonItemTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)optionButtonTapped:(id)sender {
    
    for (int i = 100; i < 103; i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        
        if (button.tag == ((UIButton *)sender).tag) {
            button.imageView.hidden = NO;
            [Appsee addEvent:@"Coupon Denied Reason Button Clicked" withProperties:@{@"reason":button.titleLabel.text}];
        }
        else {
            button.imageView.hidden = YES;
        }
        
    }
    
}

- (IBAction)continueShopping:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [Appsee addEvent:@"Coupon Denied Reason Return Button Clicked"];
}

@end
