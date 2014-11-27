//
//  HFCouponTallCell.m
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFCouponCell.h"
//Objects
#import "CouponObject.h"
#import "MerchantObject.h"

#import "UIImageView+WebCache.h"
#import "UserServerApi.h"
#import "CouponServerApi.h"

@implementation HFCouponCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.wrapperView.layer.borderColor = [HFDarkGray CGColor];
    self.wrapperView.layer.borderWidth = 0.5;
    [HFUIHelpers roundCornerToHFDefaultRadius:self.wrapperView];

}

//- (void)setIsFavorite:(BOOL)isFavorite
//{
//    _isFavorite = isFavorite;
//    if (isFavorite) {
//        [self.favoriteButton setImage:[UIImage imageNamed:@"heart_button_selected"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.favoriteButton setImage:[UIImage imageNamed:@"heart_button"] forState:UIControlStateNormal];
//    }
//}

+ (NSString *)reuseIdentifier
{
    return @"HFCouponCell";
}

+ (UINib *)cellNib
{
    return [UINib nibWithNibName:@"HFCouponCell" bundle:nil];
}

- (void)constructCellBasedOnCoupon:(CouponObject *)coupon
{
    self.couponTitleLabel.text = coupon.shortTitleCN;
    self.couponTimeLabel.text = [HFGeneralHelpers getExpireTimeStringFrom:coupon.expiredAt];
    self.expiredView.hidden = YES;
    self.expiredView.hidden = [coupon.expiredAt compare:[NSDate date]] != NSOrderedAscending;
    self.logoImageView.clipsToBounds = YES;
    self.couponCoverImageView.clipsToBounds = YES;

    if (coupon.logoImage) {
        self.logoImageView.image = coupon.logoImage;
    }
    else
    {
    [self.logoImageView setImageWithURL:[NSURL URLWithString:coupon.merchant.logoPictureUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (image && !error) {
                                      coupon.logoImage = image;
                                      self.logoImageView.image = image;
                                  }
                              }];
    }
    
    if (coupon.coverImage) {
        self.couponCoverImageView.image = coupon.coverImage;
    }
    else
    {
        [self.couponCoverImageView setImageWithURL:[NSURL URLWithString:coupon.coverPic]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      if (image && !error) {
                                          coupon.coverImage = image;
                                          self.couponCoverImageView.image = image;
                                      }
                                  }];
    };
    
    self.cmbRibbonImageView.hidden = !coupon.isExclusiveCMB;
}

/*- (IBAction)favoriteButtonClicked:(id)sender
{
    if (self.isFavorite) {
        [CouponServerApi removeFavoriteCoupon:self.coupon.itemId
                                      forUser:[UserServerApi sharedInstance].currentUserId
                                      success:^{
                                          [[NSNotificationCenter defaultCenter] postNotificationName:HFRemoveCouponFromFavorite object:self.coupon];
                                      } failure:^(NSError *error) {
                                          NSLog(@"%@",error);
                                      }];
    }
    else
    {
        [CouponServerApi addFavoriteCoupon:self.coupon.itemId
                                   forUser:[UserServerApi sharedInstance].currentUserId
                                   success:^{
                                       [[NSNotificationCenter defaultCenter] postNotificationName:HFAddCouponToFavorite object:self.coupon];
                                   } failure:^(NSError *error) {
                                       NSLog(@"%@",error);
                                   }];
    }
    [self heartAnimation];
    self.isFavorite = !self.isFavorite;
}
*/

//- (void)heartAnimation
//{
//    CATransition* transition = [CATransition animation];
//    transition.startProgress = 0;
//    transition.endProgress = 1.0;
//    transition.type = @"flip";
//    transition.subtype = @"fromRight";
//    transition.duration = 0.15;
//    transition.repeatCount = 5;
//    [self.favoriteButton.layer addAnimation:transition forKey:@"transition"];
//}

@end
