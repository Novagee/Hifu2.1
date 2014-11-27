//
//  HFCouponRedeemFailedViewController.h
//  HiFu
//
//  Created by Yin Xu on 8/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFCouponRelatedTypeEnum.h"
#import <MessageUI/MessageUI.h>

@interface HFCouponRedeemFailedViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet UIButton *feedbackButton;
@property (nonatomic, weak) IBOutlet UIView *erorrWrapperView;
@property (nonatomic, weak) IBOutlet UIImageView *erorrIconView;
@property (nonatomic, weak) IBOutlet UILabel *erorrBodyLabel;

@property (nonatomic, assign) HFCouponRedeemFailureType failureType;

- (IBAction)confirmButtonPressed:(id)sender;
- (IBAction)feedbackButtonPressed:(id)sender;

@end
