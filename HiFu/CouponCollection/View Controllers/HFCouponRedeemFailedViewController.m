//
//  HFCouponRedeemFailedViewController.m
//  HiFu
//
//  Created by Yin Xu on 8/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponRedeemFailedViewController.h"
#import "HFCouponDetailViewController.h"

@interface HFCouponRedeemFailedViewController ()

@end

@implementation HFCouponRedeemFailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupViewComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewComponents
{
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title = @"无法使用";
    [HFUIHelpers roundCornerToHFDefaultRadius:self.confirmButton];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.feedbackButton];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.erorrWrapperView];

    self.erorrWrapperView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.erorrWrapperView.layer.borderWidth = 0.5f;
    switch (self.failureType) {
        case HFCouponWrongCouponError:
            self.erorrIconView.image = [UIImage imageNamed:@"coupon_error"];
            self.erorrBodyLabel.text = @"此类商品不参加促销活动";
            break;
        case HFCouponMoneyError:
            self.erorrIconView.image = [UIImage imageNamed:@"money_error"];
            self.erorrBodyLabel.text = @"您的消费金额不足";
            break;
        case HFCouponStoreError:
            self.erorrIconView.image = [UIImage imageNamed:@"shop_error"];
            self.erorrBodyLabel.text = @"此店不参加这项促销活动";
            break;
        case HFCouponTimeError:
            self.erorrIconView.image = [UIImage imageNamed:@"time_error"];
            self.erorrBodyLabel.text = @"促销活动已经结束了";
            break;
        default:
            break;
    }
}

- (IBAction)confirmButtonPressed:(id)sender
{
    if ([self.navigationController.viewControllers count] > 1 &&
        [self.navigationController.viewControllers[1] isKindOfClass:[HFCouponDetailViewController class]]) {
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

- (IBAction)feedbackButtonPressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *feedbackController =  [[MFMailComposeViewController alloc] init];
        feedbackController.mailComposeDelegate = self;
        
        [feedbackController setSubject:[NSString stringWithFormat:@"Hi米国%@用户反馈", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]]];
        [feedbackController setToRecipients:[NSArray arrayWithObject:@"feedback@hifu.co"]];
        [feedbackController setMessageBody:@"我希望对Hi米国手机软件提一点建议:\n" isHTML:NO];
        
        [[feedbackController navigationBar] setTintColor:HFThemePink];
        [self presentViewController:feedbackController animated:YES completion:nil];
    }
}

#pragma mark - Mail Compose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送失败" message:@"邮件发送失败，请再次尝试" delegate:self cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送成功" message:@"邮件发送成功，感谢提供反馈！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
