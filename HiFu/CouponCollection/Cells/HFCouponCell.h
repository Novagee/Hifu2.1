//
//  HFCouponTallCell.h
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponObject;

@interface HFCouponCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView *wrapperView;
@property (nonatomic, weak) IBOutlet UIView *expiredView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *couponCoverImageView;
@property (nonatomic, weak) IBOutlet UILabel *couponTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *couponTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *cmbRibbonImageView;
@property (nonatomic, weak) IBOutlet UIImageView *hifuRibbonImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wrappViewLeftSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wrappViewRightSpaceConstraint;

@property (nonatomic, strong) CouponObject *coupon;

+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

- (void)constructCellBasedOnCoupon:(CouponObject *)coupon;

- (IBAction)deleteCouponButtonPressed:(id)sender;

@end