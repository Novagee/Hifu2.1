//
//  HFCouponDetailInfoCell.m
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//
#import <POP/POP.h>

#import "HFCouponDetailInfoCell.h"

#import "CouponObject.h"

@implementation HFCouponDetailInfoCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsFavorite:(BOOL)isFavorite
{
    _isFavorite = isFavorite;
    
    [self.heartButton setImage:isFavorite ? [UIImage imageNamed:@"heart_button_selected"] : [UIImage imageNamed:@"heart_button"] forState:UIControlStateNormal];
}

+ (float)cellHeightForCoupon:(CouponObject *)coupon isExpanded:(BOOL)expanded;
{
    NSString *displayText = coupon.descriptionCN ?: @"无条件";
    int height = [HFGeneralHelpers getAttributedTextHeight:displayText andFont:HeitiSC_Medium(13) andWidth:270 andLineSpace:3.0] + 20;
    if (height > 70 && expanded) {
        return 80 + height;
    }
    else if (height > 70 && !expanded) {
        return 80 + 70;
    }
    else
    {
        return 80 + height;
    }
}

+ (float)heightForCell
{
    return 150;
}

+ (NSString *)reuseIdentifier
{
    return @"HFCouponDetailInfoCell";
}

+ (UINib *)cellNib
{
    return [UINib nibWithNibName:@"HFCouponDetailInfoCell" bundle:nil];
}

- (IBAction)moreButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponDetailInfoCellMoreButtonTapped)]) {
        [self.delegate couponDetailInfoCellMoreButtonTapped];
    }
}

- (IBAction)heartButtonTapped:(id)sender
{
    self.isFavorite = !self.isFavorite;
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 6.0f;
    [self.heartButton pop_addAnimation:scaleAnimation forKey:@"POPViewScale"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponDetailInfoCellHeartButtonTapped)]) {
        [self.delegate couponDetailInfoCellHeartButtonTapped];
    }
}

- (IBAction)shareButtonTapped:(id)sender
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 6.0f;
    [self.shareButton pop_addAnimation:scaleAnimation forKey:@"POPViewScale"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponDetailInfoCellShareButtonTapped)]) {
        [self.delegate couponDetailInfoCellShareButtonTapped];
    }
}


@end
