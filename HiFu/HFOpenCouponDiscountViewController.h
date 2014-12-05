//
//  HFOpenCouponDiscountViewController.h
//  HiFu
//
//  Created by Paul on 12/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HFOpenCoupon.h"

@interface HFOpenCouponDiscountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *couponImage;
@property (copy, nonatomic) NSString *counponImageURLString;

@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponDiscount;
@property (weak, nonatomic) IBOutlet UILabel *couponExpiration;

@property (weak, nonatomic) IBOutlet UITextView *storeAddress;

@property (weak, nonatomic) IBOutlet UIScrollView *mainBottom;

@property (strong, nonatomic) HFOpenCoupon *openCoupon;

@end
