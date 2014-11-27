//
//  HFCouponDiscount.m
//  HiFu
//
//  Created by Paul on 11/14/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponGiftView.h"

@implementation HFCouponGiftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)useDiscountTapped:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(discountCell:)]) {
        [_delegate discountCell:sender];
    }
    
}


@end
