//
//  YXAvatarCollectionCell.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXAvatarCollectionCell.h"

@implementation YXAvatarCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    return @"YXAvatarCollectionCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXAvatarCollectionCell" bundle:nil];
}

@end
