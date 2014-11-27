//
//  YXMeSettingNameCell.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeSettingNameCell.h"

@implementation YXMeSettingNameCell

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
    return 44;
}

+ (NSString *)reuseIdentifier
{
    return @"YXMeSettingNameCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXMeSettingNameCell" bundle:nil];
}

@end
