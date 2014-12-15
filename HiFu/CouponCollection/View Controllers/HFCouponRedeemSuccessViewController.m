//
//  HFCouponRedeemSuccessViewController.m
//  HiFu
//
//  Created by Yin Xu on 8/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponRedeemSuccessViewController.h"
#import "HFShareHelpers.h"
#import "CouponObject.h"
#import <Appsee/Appsee.h>

@interface HFCouponRedeemSuccessViewController ()

@end

@implementation HFCouponRedeemSuccessViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self runAppearAnimation];
}

- (void)setupViewComponents
{
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.blurBackgroundImageView.image = self.blurBackgroundImage;
    self.mainWrapperView.alpha = 0.0f;
}

- (void)runAppearAnimation
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainWrapperView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)confirmButtonPressed:(id)sender
{
    [Appsee addEvent:@"Coupon Used Confirm Button Clicked"];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareByMessageButtonPressed:(id)sender
{
    [Appsee addEvent:@"Coupon Success Shared By SMS Button Clicked"];
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers shareByMessageOnViewController:self
                                       andDelegate:self
                                     sharedSubject:self.coupon.shareTitle
                                        sharedBody:[NSString stringWithFormat:@"%@ 活动详情:\n %@", self.coupon.shareContent, self.coupon.shareTitle]
                                       sharedImage:self.coupon.shareImage
                                 presentCompletion:nil];
}

- (void)shareByEmailButtonPressed:(id)sender
{
    [Appsee addEvent:@"Coupon Success Shared By Email Button Clicked"];
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers shareByEmailOnViewController:self
                                     andDelegate:self
                                   sharedSubject:self.coupon.shareTitle
                                      sharedBody:[NSString stringWithFormat:@"%@ 活动详情:\n %@", self.coupon.shareContent, self.coupon.shareTitle]
                                     sharedImage:self.coupon.shareImage
                               presentCompletion:nil];

}

- (void)shareBySinaWeiboButtonPressed:(id)sender
{
    [Appsee addEvent:@"Coupon Success Shared By Sina Weibo Button Clicked"];
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers sharedBySinaWeiboOnViewController:self
                                        andSharedText:[NSString stringWithFormat:@"%@ %@", self.coupon.shareContent?:@"", self.coupon.shareLink?:@""]
                                          sharedImage:self.coupon.shareImage];
}

- (void)shareByAirDropButtonPressed:(id)sender
{
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers sharedByAirDropOnViewController:self andSharedText:[NSString stringWithFormat:@"%@ %@", self.coupon.shareContent, self.coupon.shareLink] andSharedImage:self.coupon.shareImage];
}

- (void)shareByWechatMessageButtonPressed:(id)sender
{
    NSLog(@"WeChat Message");
    
    [Appsee addEvent:@"Coupon Success Shared By Wechat SMS Button Clicked"];
    [self actualShareOnWechat:YES];
}

- (void)shareByWechatMomentButtonPressed:(id)sender
{
    NSLog(@"WeChat Moment");
    [Appsee addEvent:@"Coupon Success Shared By Wechat Moment Button Clicked"];
    [self actualShareOnWechat:YES];
}

- (void)actualShareOnWechat:(BOOL) isMoment
{
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers shareByWechat:isMoment
                   andSharedTitle:self.coupon.shareTitle
                       sharedBody:[NSString stringWithFormat:@"%@ 活动详情:\n %@", self.coupon.shareContent, self.coupon.shareTitle]
                       thumbImage:[UIImage imageNamed:@"HiFu_App_Icon"]
                      sharedImage:self.coupon.shareImage
                          success:^{
//                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
//                                                                              message:isMoment ? @"朋友圈发送成功!" : @"微信发送成功!"
//                                                                             delegate:nil
//                                                                    cancelButtonTitle:@"返回"
//                                                                    otherButtonTitles: nil];
//                              [alert show];
                          } failure:^{
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                              message:isMoment ? @"朋友圈发送失败，请稍微尝试。" : @"微信发送失败，请稍后尝试。"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"好的"
                                                                    otherButtonTitles: nil];
                              [alert show];
                          }];
}

#pragma mark - Mail Compose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [Appsee addEvent:@"Coupon Success Shared By MAIL Button Clicked"];
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送失败" message:@"邮件发送失败，请再次尝试" delegate:self cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送成功" message:@"邮件发送成功，感谢分享！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信发送失败" message:@"短信发送失败，请再次尝试" delegate:self cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (result == MessageComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信发送成功" message:@"短信发送成功，感谢分享！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareByQQButtonPressed:(id)sender{
    [Appsee addEvent:@"Coupon Success Shared By QQ Button Clicked"];
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    [HFShareHelpers sharedByQQOnViewController:self andShareTitle:self.coupon.shareTitle shareBody:self.coupon.shareContent sharedImage:self.coupon.shareImage success:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                        message:@"QQ发送成功!"
                                                       delegate:nil
                                              cancelButtonTitle:@"返回"
                                              otherButtonTitles: nil];
        [alert show];
        
    } failure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"QQ发送失败，请稍后尝试。"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles: nil];
        [alert show];
        
    }];
}

@end
