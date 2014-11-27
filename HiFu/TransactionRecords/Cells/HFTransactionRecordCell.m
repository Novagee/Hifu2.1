//
//  HFTransactionRecordCell.m
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFTransactionRecordCell.h"

@implementation HFTransactionRecordCell

- (void)awakeFromNib
{
    self.innerView.layer.cornerRadius = 6;
    self.innerView.clipsToBounds = YES;
    self.innerView.layer.borderColor = [[UIColor colorWithWhite:0.824 alpha:1.000] CGColor];
    self.innerView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 98;
}

+ (NSString *)reuseIdentifier
{
    return @"HFTransactionRecordCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFTransactionRecordCell" bundle:nil];
}

@end
