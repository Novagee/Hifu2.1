//
//  YXCalendarDestinationCell.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/15/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXCalendarSelectRange , WeatherObject;
@interface YXCalendarDestinationCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UILabel *cellTopBarLabel; //match the range theme color when highlighted
@property (nonatomic, weak) IBOutlet UILabel *cellBottomBarLabel; //only show when highlighted, color match the theme color
@property (nonatomic, weak) IBOutlet UILabel *cellRightBarLabel; //only show when highlighted, color match the theme color

@property (nonatomic, weak) IBOutlet UILabel *colorLabel;
@property (nonatomic, weak) IBOutlet UILabel *colorLabelRightSide;
@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateToLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationNameLabel;

@property (nonatomic, weak) IBOutlet UIView *detailInfoView;
@property (nonatomic, weak) IBOutlet UIView *weaterhInfoView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *weatherActivityLoader;
@property (nonatomic, weak) IBOutlet UILabel *tempNumberLabel;
@property (nonatomic, weak) IBOutlet UIImageView *tempIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *taxNumberLabel;



@property (nonatomic, strong) YXCalendarSelectRange *range;
@property (nonatomic, strong) WeatherObject *weather;

+ (float)heightForCell;
+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

@end
