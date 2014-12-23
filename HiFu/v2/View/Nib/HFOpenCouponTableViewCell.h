//
//  HFOpenCouponTableViewCell.h
//  HiFu
//
//  Created by Peng Wan on 11/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFOpenCoupon.h"

@interface HFOpenCouponTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *couponImage;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponDiscount;
@property (weak, nonatomic) IBOutlet UILabel *couponExpiration;
@property (weak, nonatomic) IBOutlet UIButton *couponDetailButton;

-(void) setUpCoupon:(HFOpenCoupon *)openCoupon inRow:(NSInteger)row;

@end
