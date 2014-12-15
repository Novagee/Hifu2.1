//
//  HFDiscountViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/10/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFDiscountViewController.h"
#import "HFDiscountReasonViewController.h"

#import "HFShareView.h"
#import "HFShareHelpers.h"
#import <MessageUI/MessageUI.h>
#import "SDWebImageDownloader.h"
#import "HFCouponRedeemSuccessViewController.h"
#import "HFCouponApi.h"
#import "HFCouponApi.h"
#import "UserServerApi.h"
#import "UserObject.h"
#import <Appsee/Appsee.h>
#import <AFNetworking/AFNetworking.h>
#import "HFUIHelpers.h"
#import "UIView+EasyFrames.h"

@interface HFDiscountViewController ()<HFShareViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bottomView;

@property (strong, nonatomic) HFShareView *shareView;
@property (weak, nonatomic) IBOutlet UIView *couponTopView;
@property (weak, nonatomic) IBOutlet UIView *discountCNView;
@property (weak, nonatomic) IBOutlet UIView *discountRuleView;

@end

@implementation HFDiscountViewController

@synthesize shareView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    
    // Configure Left Bar button Item
    //
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xButton"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapped)];
    leftBarButton.tintColor = [UIColor colorWithRed:255/255 green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // Configure Right Bar Button Item
    //
    UIImage *buttonImage = [UIImage imageNamed:@"share"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];;
    
    // Configure the scroll view
    //
    _bottomView.contentSize = CGSizeMake(self.bottomView.bounds.size.width, 800);

    self.navigationItem.title = @"Redemption";
    
    // Coupon user collection
    //
    [HFCouponApi collectCoupon:self.coupon.couponId withUserId:[UserServerApi sharedInstance].currentUserId success:^{
        NSLog(@"Coupon Collected Successfully");
    } failure:^(NSError *error) {
        NSLog(@"Coupon Collected Fail");
    }];
    
    // Configure Discount Infos
    //
    [self configureDiscountViewSection];
}

- (void)viewDidLayoutSubviews {
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure Discount View Section

- (void)configureDiscountViewSection {
    
    self.salesLabel.text = [NSString stringWithFormat:@"Hi %@,",self.salesName?:@""];
    self.descriptionCN.text = self.coupon.briefDescriptionCN;
    self.rule.text = self.coupon.descriptionCN;
    self.descriptionEN.text = self.coupon.descriptionEN;
    self.code.text = self.coupon.code;
    
    NSURLRequest *fetchImageRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.coupon.backgroundPictureURL]];
    [self fetchImageWithRequest:fetchImageRequest finished:^(id responseObject) {
       
        NSLog(@"Image URL : %@", responseObject);
        
        self.discountImage.image = [[UIImage alloc]initWithData:responseObject];
        
    }];
    
    //Dynamic resize the view
    //
    [self.descriptionCN sizeToFit];
    self.discountCNView.frame = CGRectMake(self.discountCNView.origin.x, self.discountCNView.origin.y, self.discountCNView.width, self.discountCNView.height + self.descriptionCN.height);
    
    [self.rule sizeToFit];
    self.discountRuleView.frame = CGRectMake(self.discountRuleView.origin.x, self.discountRuleView.origin.y + self.descriptionCN.height/2, self.discountRuleView.width, self.discountRuleView.height + self.rule.height);
    
    if (!self.coupon.backgroundPictureURL||[@"" isEqualToString:self.coupon.backgroundPictureURL]) {
        int imageHeight = 180;
        self.couponTopView.frame = CGRectMake(self.couponTopView.frame.origin.x, self.couponTopView.frame.origin.y, self.couponTopView.frame.size.width, self.couponTopView.frame.size.height-imageHeight);
        self.discountCNView.frame = CGRectMake(self.discountCNView.frame.origin.x, self.discountCNView.origin.y-imageHeight, self.discountCNView.size.width, self.discountCNView.size.height);
        
        self.discountRuleView.frame = CGRectMake(self.discountRuleView.frame.origin.x, self.discountRuleView.origin.y-imageHeight, self.discountRuleView.size.width, self.discountRuleView.size.height);

    }
    _bottomView.contentSize = CGSizeMake(self.bottomView.bounds.size.width, self.discountRuleView.origin.y + self.discountRuleView.height + 100);
    
}

- (void)fetchImageWithRequest:(NSURLRequest *)request finished:(void(^)(id responseObject))success {
    
    // Fetch image
    //
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    httpRequestOperation.responseSerializer.acceptableContentTypes = nil;
    
    [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [httpRequestOperation start];
    
}

#pragma mark - Navigation Items

- (void)leftBarButtonTapped {
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightBarButtonTapped {
    [Appsee addEvent:@"Redemption Shared" withProperties:@{@"couponId":self.coupon.couponId}];
    if (!shareView) {
        shareView = [[NSBundle mainBundle] loadNibNamed:@"HFShareView" owner:self options:nil][0];
        shareView.delegate = self;
    }
    
    shareView.alpha = 0.0;
    //    shareView.shareWrapperView.frame = CGRectMake(0, HF_DEVICE_HEIGHT, 320, shareView.shareWrapperView.height);
    
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        shareView.alpha = 1.0;
        [shareView runShowAnimation];
    } completion:nil];
    
//    [Appsee addEvent:@"CouponApplied" withProperties:@{@"couponId":self.coupon.couponId}];
//    //    self.tabBarController.tabBar.hidden = NO;
//    //    [self.navigationController popToRootViewControllerAnimated:YES];
//    [HFCouponApi applyCoupon:self.coupon.couponId withUserId:[UserServerApi sharedInstance].currentUserId success:^{
//        NSLog(@"Coupon %@ Applied Successfully",self.coupon.couponId);
//    } failure:^(NSError *error) {
//        NSLog(@"Coupon %@ Applied Fail",self.coupon.couponId);
//    }];
//    
//    HFCouponRedeemSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HFCouponRedeemSuccessViewController"];
//    vc.blurBackgroundImage = [HFUIHelpers takeScreenShotForViewController:self andApplyBlurEffect:YES andBlurRadius:8];
//    vc.coupon = self.coupon;
//    [self.navigationController pushViewController:vc animated:NO];
    
}

- (IBAction)deniedTapped:(id)sender {
    [Appsee addEvent:@"Coupon Denied Button Clicked" withProperties:@{@"couponId":self.coupon.couponId}];
    [HFCouponApi denyCoupon:self.coupon.couponId withUserId:[UserServerApi sharedInstance].currentUserId success:^{
        NSLog(@"Coupon %@ Denied Successfully",self.coupon.couponId);
    } failure:^(NSError *error) {
        NSLog(@"Coupon %@ Denied Fail",self.coupon.couponId);
    }];
    HFDiscountReasonViewController *discountReasonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"discountReason"];
    [self.navigationController pushViewController:discountReasonViewController animated:YES];
    
}

- (IBAction)applied:(id)sender {
    [Appsee addEvent:@"Coupon Applied Button Clicked" withProperties:@{@"couponId":self.coupon.couponId}];
//    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [HFCouponApi applyCoupon:self.coupon.couponId withUserId:[UserServerApi sharedInstance].currentUserId success:^{
        NSLog(@"Coupon %@ Applied Successfully",self.coupon.couponId);
    } failure:^(NSError *error) {
        NSLog(@"Coupon %@ Applied Fail",self.coupon.couponId);
    }];
    
    HFCouponRedeemSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HFCouponRedeemSuccessViewController"];
    vc.blurBackgroundImage = [HFUIHelpers takeScreenShotForViewController:self andApplyBlurEffect:YES andBlurRadius:8];
    vc.coupon = self.coupon;
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark - HFShareView Delegate

- (void)sharedByMessage
{
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
                                 presentCompletion:^{
                                     [self dismissShareView];
                                     
                                 }];
}

- (void)sharedByEmail
{
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
                               presentCompletion:^{
                                   [self dismissShareView];
                                   
                               }];
}

- (void)sharedBySinaWeibo
{
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers sharedBySinaWeiboOnViewController:self
                                        andSharedText:[NSString stringWithFormat:@"%@ %@", self.coupon.shareContent, self.coupon.shareLink]
                                          sharedImage:self.coupon.shareImage];
}

- (void)sharedByQQ
{
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

- (void)sharedByAirDrop
{
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers sharedByAirDropOnViewController:self andSharedText:[NSString stringWithFormat:@"%@ %@", self.coupon.shareContent, self.coupon.shareLink] andSharedImage:self.coupon.shareImage];
    
    [self dismissShareView];
}

- (void)sharedByWechatMessage
{
    [self actualShareOnWechat:NO];
}

- (void)sharedByWechatMoment
{
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
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                                              message:isMoment ? @"朋友圈发送成功!" : @"微信发送成功!"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"返回"
                                                                    otherButtonTitles: nil];
                              [alert show];
                          } failure:^{
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                              message:isMoment ? @"朋友圈发送失败，请稍微尝试。" : @"微信发送失败，请稍后尝试。"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"好的"
                                                                    otherButtonTitles: nil];
                              [alert show];
                          }];
}

- (void)dismissShareView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        shareView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        shareView = nil;
    }];
}

- (void)getShareImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.coupon.sharePictureURL]
                                                              options:SDWebImageDownloaderUseNSURLCache
                                                             progress:nil
                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                if (finished && image) {
                                                                    self.coupon.shareImage = image;
                                                                }
                                                            }];
    });
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



@end
