//
//  YXMeSettingPhoneCell.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeSettingPhoneCell.h"

@implementation YXMeSettingPhoneCell

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
    return @"YXMeSettingPhoneCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXMeSettingPhoneCell" bundle:nil];
}

@end
