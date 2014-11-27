//
//  YXCalendarDayView.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarEnum.h"

@interface YXCalendarDayView : UIView

@property (nonatomic, copy) NSDateComponents *day;
@property (nonatomic, copy) NSDate *dateForDay;
@property (nonatomic, assign) YXCalendarDayViewState dayViewState;
@property (nonatomic, assign) YXCalendarDayViewPositionType positionType;
@property (nonatomic, assign) BOOL inCurrentMonth;
@property (nonatomic, assign) int indexOfSelection;
@property (nonatomic, assign) int selectedBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
