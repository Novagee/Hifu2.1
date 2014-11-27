//
//  YXMeSettingGenderCell.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeSettingGenderCell.h"

@implementation YXMeSettingGenderCell

- (void)awakeFromNib
{
    [self.genderSegmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:15]} forState:UIControlStateNormal];
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
    return @"YXMeSettingGenderCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXMeSettingGenderCell" bundle:nil];
}

- (IBAction)genderSgmentedControlValueChanged:(id)sender
{
    NSString *gender = @"";
    if (self.genderSegmentedControl.selectedSegmentIndex == 0) {
        gender = @"Male";
    }
    else
    {
        gender = @"Female";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userGenderValueChanged" object:gender];

}

@end
