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
