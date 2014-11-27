//
//  YXMeSettingAvatarCell.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeSettingAvatarCell.h"

@implementation YXMeSettingAvatarCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 100;
}

+ (NSString *)reuseIdentifier
{
    return @"YXMeSettingAvatarCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXMeSettingAvatarCell" bundle:nil];
}

@end
