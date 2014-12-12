//
//  HFPreOrderViewController.m
//  HiFu
//
//  Created by Peng Wan on 12/4/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFPreOrderViewController.h"
#import "UserServerApi.h"

@interface HFPreOrderViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *preorderWV;
@property (strong, nonatomic) UIView *statusBarBottom;

@end

@implementation HFPreOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.preorderWV.scalesPageToFit = YES;
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.hifu.co/v3/index.html?userId=%@",[UserServerApi sharedInstance].currentUserId];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.preorderWV loadRequest:requestObj];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.preorderWV.scrollView.bounces=NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLayoutSubviews {
    
    // Add status bar bottom
    //
    _statusBarBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    _statusBarBottom.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.statusBarBottom];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.statusBarBottom removeFromSuperview];
    
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
