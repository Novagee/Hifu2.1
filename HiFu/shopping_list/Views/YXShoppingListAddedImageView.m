//
//  YXShoppingListAddedImageView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/19/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXShoppingListAddedImageView.h"

@implementation YXShoppingListAddedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithNib
{
    self = [[UINib nibWithNibName:@"YXShoppingListAddedImageView" bundle:nil] instantiateWithOwner:nil options:NULL][0];
    if (self) {
        [HFUIHelpers roundCornerToHFDefaultRadius:self.imageView];
    }
    return self;
}

@end
