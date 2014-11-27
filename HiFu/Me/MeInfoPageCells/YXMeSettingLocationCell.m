//
//  YXMeSettingLocationCell.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeSettingLocationCell.h"

@implementation YXMeSettingLocationCell

- (void)awakeFromNib
{
    [self.countrySegmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:15]} forState:UIControlStateNormal];
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
    return @"YXMeSettingLocationCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXMeSettingLocationCell" bundle:nil];
}

- (IBAction)countrySgmentedControlValueChanged:(id)sender
{
    NSString *country = @"";
    if (self.countrySegmentedControl.selectedSegmentIndex == 0) {
        country = @"China";
    }
    else
    {
        country = @"US";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userCountryValueChanged" object:country];
}

@end
