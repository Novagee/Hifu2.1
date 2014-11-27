//
//  HFCouponRedeemViewController.h
//  HiFu
//
//  Created by Yin Xu on 8/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponObject;
@interface HFCouponRedeemViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *topWrapperView;
@property (nonatomic, weak) IBOutlet UIView *showCrashierLabelView;
@property (nonatomic, weak) IBOutlet UIView *couponImageWrapperView;
@property (nonatomic, weak) IBOutlet UILabel *promotionCodeLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, weak) IBOutlet UIImageView *redeemImageView;
@property (nonatomic, weak) IBOutlet UIButton *appliedButton;
@property (nonatomic, weak) IBOutlet UIButton *sorryButton;

@property (nonatomic, weak) IBOutlet UIView *bottomWrapperView;
@property (nonatomic, weak) IBOutlet UIView *bottomTitleLabel;
@property (nonatomic, weak) IBOutlet UIView *bottomMiddleLabel;
@property (nonatomic, weak) IBOutlet UIView *couponErrorView;
@property (nonatomic, weak) IBOutlet UIView *moneyErrorView;
@property (nonatomic, weak) IBOutlet UIView *storeErrorView;
@property (nonatomic, weak) IBOutlet UIView *timeErrorView;

@property (nonatomic, weak) IBOutlet UIImageView *couponErrorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *moneyErrorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *storeErrorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *timeErrorImageView;

@property (nonatomic, weak) IBOutlet UILabel *couponErrorLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyErrorLabel;
@property (nonatomic, weak) IBOutlet UILabel *storeErrorLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeErrorLabel;

@property (nonatomic, weak) IBOutlet UIButton *showToCustomerButton;

@property (nonatomic, strong) CouponObject *coupon;

- (IBAction)expandButtonTapped:(id)sender;

- (IBAction)acceptCouponTapped:(id)sender;
- (IBAction)notAcceptCoupontTapped:(id)sender;
- (IBAction)showToCustomerTapped:(id)sender;

- (IBAction)couponFailureTapped:(id)sender;
- (IBAction)moneyFailureTapped:(id)sender;
- (IBAction)storeFailureTapped:(id)sender;
- (IBAction)timeFailureTapped:(id)sender;

@end
