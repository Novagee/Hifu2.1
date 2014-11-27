//
//  NSDate+YXCalendarViewHelper.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YXCalendarViewHelper)

- (NSInteger)weekdayOfDateInCalendar:(NSCalendar*)calendar;
- (NSDateComponents*)dayOfCalendar:(NSCalendar*)calendar;
- (NSDateComponents*)monthOfCalendar:(NSCalendar*)calendar;

@end
