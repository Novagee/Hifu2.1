//
//  HFCustomPageControl.h
//  HiFu
//
//  Created by Yin Xu on 9/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFCustomPageControl : UIPageControl

@property (nonatomic, strong) UIImage* activeImage;
@property (nonatomic, strong) UIImage* inactiveImage;
@property (nonatomic, assign) CGSize dotSize;

-(id)initWithActiveImage: (UIImage *)acitveImage
        andInactiveImage: (UIImage *)inactiveImage
              andDotSize: (CGSize)size;

@end
