//
//  HFDiscountViewController.h
//  HiFu
//
//  Created by Peng Wan on 10/10/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CouponObject.h"

@protocol HFShareViewDelegate;
@interface HFDiscountViewController : UIViewController

@property (strong, nonatomic) CouponObject *coupon;

@property (strong, nonatomic) NSString *salesName;

@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionCN;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UIImageView *discountImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionEN;
@property (weak, nonatomic) IBOutlet UITextView *rule;


@property (nonatomic, assign) id<HFShareViewDelegate> delegate;

@end

@protocol HFShareViewDelegate <NSObject>

- (void)sharedByMessage;
- (void)sharedByEmail;
- (void)sharedBySinaWeibo;
- (void)sharedByAirDrop;
- (void)sharedByWechatMessage;
- (void)sharedByWechatMoment;
- (void)dismissShareView;

@end
