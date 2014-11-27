//
//  CALayer+CGCategories.m
//  HiFu
//
//  Created by Peng Wan on 28/9/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "CALayer+CGCategories.h"

@implementation CALayer (CGCategories)

- (void)setLayerBorderColor:(UIColor *)layerBorderColor {
    self.borderColor = layerBorderColor.CGColor;
}

- (UIColor *)layerBorderColor {
    return self.layerBorderColor;
}

- (void)setLayerShadowColor:(UIColor *)layerShadowColor {
    self.shadowColor = layerShadowColor.CGColor;
}

- (UIColor *)layerShadowColor {
    return self.layerShadowColor;
}

@end
