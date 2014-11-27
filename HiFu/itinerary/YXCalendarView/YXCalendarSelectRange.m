//
//  YXCalendarSelectRange.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/12/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarSelectRange.h"

@implementation YXCalendarSelectRange
- (id)initWithStartDay:(NSDateComponents *)start endDay:(NSDateComponents *)end andIndex:(NSInteger)index {
    self = [super init];
    if (self != nil) {
        // Initialise properties
        _startDay = start;
        _startDate = [start date];
        _endDay = end;
        _endDate = [end date];
        _dayViewsArray = [NSMutableArray new];
        self.index = index;
    }
    
    return self;
}

- (BOOL)containsDay:(NSDateComponents*)day {
    return [self containsDate:day.date];
}

- (BOOL)containsDate:(NSDate*)date {
    if ([_startDate compare:date] == NSOrderedDescending) {
        return NO;
    }
    else if ([_endDate compare:date] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

@end
