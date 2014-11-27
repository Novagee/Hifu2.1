//
//  HFMagicButton.m
//  HiFu
//
//  Created by Peng Wan on 10/12/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFMagicButton.h"

@implementation HFMagicButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithImage:(UIImage *)image {
    
    if (self = [super init]) {
        
        // Fetch the current screen's width
        //
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        self.frame = CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height);
        self.center = CGPointMake(screenWidth, 20);
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:imageView];
    }
    return self;
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([_delegate respondsToSelector:@selector(magicButtonTapped:)]) {
        [_delegate magicButtonTapped:nil];
    }
    
}

@end
