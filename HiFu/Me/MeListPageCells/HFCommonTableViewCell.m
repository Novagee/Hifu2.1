//
//  HFCommonTableViewCell.m
//  HiFu
//
//  Created by Peng Wan on 12/4/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCommonTableViewCell.h"

@implementation HFCommonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 45;
}

+ (NSString *)reuseIdentifier
{
    return @"HFCommonTableViewCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFCommonTableViewCell" bundle:nil];
}

@end
