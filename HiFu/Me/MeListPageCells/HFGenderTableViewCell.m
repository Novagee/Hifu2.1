//
//  HFGenderTableViewCell.m
//  HiFu
//
//  Created by Peng Wan on 10/24/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFGenderTableViewCell.h"

@implementation HFGenderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 44;
}

+ (NSString *)reuseIdentifier
{
    return @"HFGenderTableViewCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFGenderTableViewCell" bundle:nil];
}

@end
