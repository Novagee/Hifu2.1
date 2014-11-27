//
//  GBImageCollectionItemCell.m
//  Gogobot-iOS
//
//  Created by Yin Xu on 11/12/13.
//  Copyright (c) 2013 Gogobot. All rights reserved.
//

#import "YXImageCollectionItemCell.h"

@implementation YXImageCollectionItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.isImageSelected = NO;
}

- (void)prepareForReuse
{
    self.isImageSelected = NO;
}

- (void)checkImage
{
    self.isImageSelected = !self.isImageSelected;
    self.checkImageView.image = self.isImageSelected ? [UIImage imageNamed:@"checkMark"] : nil;
}

+ (NSString *)reuseIdentifier
{
    return @"YXImageCollectionItemCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXImageCollectionItemCell" bundle:nil];
}


@end
