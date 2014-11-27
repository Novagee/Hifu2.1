//
//  HFOpenCouponTableViewCell.m
//  HiFu
//
//  Created by Peng Wan on 11/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFOpenCouponTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HFOpenCouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setUpCoupon:(HFOpenCoupon *)openCoupon{
    [self.couponImage setImageWithURL:[NSURL URLWithString:openCoupon.brandPicUrl]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if (image && !error) {
                                  self.couponImage.image = image;
                              }
                          }];
    self.couponTitle.text = [NSString stringWithFormat:@"%@ %@",openCoupon.brand, openCoupon.brandCN];
    self.couponDiscount.text = openCoupon.titleCN;
    self.couponExpiration.text = [NSString stringWithFormat:@"%@前有效",openCoupon.expireDateDisplay];
    
    
}

@end
