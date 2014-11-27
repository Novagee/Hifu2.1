//
//  YXShoppingListItemCell.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/21/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXShoppingListItemCell.h"

@implementation YXShoppingListItemCell

- (void)awakeFromNib
{
    [HFUIHelpers roundCornerToHFDefaultRadius:self.innerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (UIView *v in self.innerView.subviews) {
        if (![v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
}

+ (float)heightForCell
{
    return 110;
}

+ (NSString *)reuseIdentifier
{
    return @"YXShoppingListItemCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXShoppingListItemCell" bundle:nil];
}


@end
