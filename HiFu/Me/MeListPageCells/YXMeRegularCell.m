//
//  YXMeRegularCell.m
//  HiFu
//
//  Created by Yin Xu on 7/1/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeRegularCell.h"

@implementation YXMeRegularCell

- (void)awakeFromNib
{
    self.topSeparatorImageView.frame = CGRectMake(0, 0, 320, 0.5);
    self.bottomSeparatorImageView.frame = CGRectMake(0, self.frame.size.height - 0.5, 320, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 44;
}

+ (NSString *)reuseIdentifier
{
    return @"YXMeRegularCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXMeRegularCell" bundle:nil];
}

@end
