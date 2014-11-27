//
//  HFRangeViewButton.m
//  HiFu
//
//  Created by Peng Wan on 10/14/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFRangeViewButton.h"
#import "HFMacro.h"

@implementation HFRangeViewButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTapped:(BOOL)tapped {
    
    if (tapped) {
        
        [self setBackgroundColor:HF_MAIN_COLOR];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        return ;
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return ;
    
}

@end
