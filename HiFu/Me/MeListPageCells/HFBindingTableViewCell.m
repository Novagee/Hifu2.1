//
//  HFBindingTableViewCell.m
//  HiFu
//
//  Created by Peng Wan on 10/24/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFBindingTableViewCell.h"

@implementation HFBindingTableViewCell

- (void)awakeFromNib
{
    _bindingSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
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
    return @"HFBindingTableViewCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFBindingTableViewCell" bundle:nil];
}

@end
