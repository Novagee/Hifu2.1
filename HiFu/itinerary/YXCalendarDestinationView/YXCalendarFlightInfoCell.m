//
//  YXCalendarFlightInfoCell.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/16/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarFlightInfoCell.h"

@implementation YXCalendarFlightInfoCell

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 65;
}

+ (NSString *)reuseIdentifier
{
    return @"YXCalendarFlightInfoCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXCalendarFlightInfoCell" bundle:nil];
}


@end
