//
//  YXCalendarDestinationCell.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/15/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarDestinationCell.h"

@implementation YXCalendarDestinationCell

- (void)awakeFromNib
{
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.detailInfoView.hidden = YES;
    self.startDateLabel.text = @"";
    self.endDateLabel.text = @"";
    self.destinationNameLabel.text = @"";
    self.tempNumberLabel.text = @"";
    self.tempIconImageView.image = nil;
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
    return @"YXCalendarDestinationCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXCalendarDestinationCell" bundle:nil];
}


@end
