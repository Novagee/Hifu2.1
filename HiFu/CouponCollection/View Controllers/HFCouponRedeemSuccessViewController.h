//
//  HFCouponRedeemSuccessViewController.h
//  HiFu
//
//  Created by Yin Xu on 8/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class CouponObject;
@interface HFCouponRedeemSuccessViewController : UIViewController <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic ,weak) IBOutlet UIButton *noShareButton;
@property (nonatomic ,weak) IBOutlet UIImageView *blurBackgroundImageView;
@property (nonatomic ,weak) IBOutlet UIView *mainWrapperView;

@property (nonatomic ,strong) UIImage *blurBackgroundImage;
@property (nonatomic ,strong) CouponObject *coupon;

- (IBAction)confirmButtonPressed:(id)sender;
- (IBAction)shareByEmailButtonPressed:(id)sender;
- (IBAction)shareByMessageButtonPressed:(id)sender;
- (IBAction)shareByWechatMessageButtonPressed:(id)sender;
- (IBAction)shareByWechatMomentButtonPressed:(id)sender;
- (IBAction)shareByAirDropButtonPressed:(id)sender;
- (IBAction)shareBySinaWeiboButtonPressed:(id)sender;
- (IBAction)shareByQQButtonPressed:(id)sender;


@end
