//
//  YXDestinationSearchResultCell.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/15/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXDestinationSearchResultCell.h"

@implementation YXDestinationSearchResultCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    self.destinationNameLabel.text = @"";
    self.destinationNameLabel.textColor = [UIColor whiteColor];
    self.destinationStateNameLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
}


+ (float)heightForCell
{
    return 50;
}

+ (NSString *)reuseIdentifier
{
    return @"YXDestinationSearchResultCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"YXDestinationSearchResultCell" bundle:nil];
}

- (void)highlightDestinationNameWithColor:(UIColor *)color
{
    self.destinationNameLabel.textColor = color ?: HFThemePink;
    self.destinationStateNameLabel.textColor = color ?: HFThemePink;
}

@end
