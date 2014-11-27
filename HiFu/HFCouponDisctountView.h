//
//  HFCouponGiftView.h
//  HiFu
//
//  Created by Paul on 11/13/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFCouponDisctountViewDelegate <NSObject>

- (void)giftCell:(UIButton *)button;

@end

@interface HFCouponDisctountView : UIView

@property (weak, nonatomic) id<HFCouponDisctountViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *briefDescriptionCN;

@property (weak, nonatomic) IBOutlet UITextView *descCN;
@property (weak, nonatomic) IBOutlet UIImageView *discountImg;

@end
