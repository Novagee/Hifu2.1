//
//  HFChineseHelpViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFChineseHelpViewController.h"

@interface HFChineseHelpViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@end

@implementation HFChineseHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureBackgroundImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure UI

- (void)configureBackgroundImage {
    
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _blurImageView.image = self.blurBackgroundImage;
    
}

- (IBAction)completeHelp:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.navigationController popViewControllerAnimated:NO];
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
