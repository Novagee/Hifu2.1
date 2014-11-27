//
//  NSDate+YXCalendarViewHelper.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "NSDate+YXCalendarViewHelper.h"

@implementation NSDate (YXCalendarViewHelper)

- (NSDateComponents*)dayOfCalendar:(NSCalendar*)calendar {
    return [calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:self];
}

- (NSInteger)weekdayOfDateInCalendar:(NSCalendar*)calendar
{
    [calendar setFirstWeekday:2];
    return [calendar components:NSWeekdayCalendarUnit fromDate:self].weekday;
}

- (NSDateComponents*)monthOfCalendar:(NSCalendar*)calendar {
    return [calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
}

@end
