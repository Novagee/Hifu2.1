//
//  HFShareBuyViewController.m
//  HiFu
//
//  Created by Kelvin Lam on 10/9/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFDiscountShareViewController.h"
#import "HFDiscountProblemViewController.h"

@interface HFDiscountShareViewController ()

@end

@implementation HFDiscountShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)problemTapped:(id)sender {
    
    HFDiscountProblemViewController *discountProblemViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HFDiscountProblemViewController"];
//    [self presentViewController:discountProblemViewController animated:YES completion:nil];
    [self.navigationController pushViewController:discountProblemViewController animated:YES];
}

- (IBAction)continueButtonTapped:(id)sender {
    UITabBarController *storeView  =  [self.storyboard instantiateViewControllerWithIdentifier:@"browserTabs"];
    [self presentViewController:storeView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
