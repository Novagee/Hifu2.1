//
//  HFCouponGiftView.m
//  HiFu
//
//  Created by Paul on 11/13/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponDisctountView.h"

@implementation HFCouponDisctountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)giftButtonTapped:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(giftCell:)]) {
        [_delegate giftCell:sender];
    }
    
}
@end
