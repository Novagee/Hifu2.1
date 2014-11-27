//
//  HFCouponDiscount.h
//  HiFu
//
//  Created by Paul on 11/14/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFCouponGiftViewDelegate <NSObject>

- (void)discountCell:(UIButton *)button;

@end

@interface HFCouponGiftView : UIView

@property (weak, nonatomic) id<HFCouponGiftViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *briefDescriptionCN;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *descCN;
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;

@end
