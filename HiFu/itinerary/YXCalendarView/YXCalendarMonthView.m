//
//  YXCalendarMonthView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarMonthView.h"
#import "YXCalendarDayView.h"
#import "NSDate+YXCalendarViewHelper.h"

@implementation YXCalendarMonthView
{
    NSArray *dayViewWidths;
}

NSInteger const daysPerWeek = 7;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dayViewsDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithMonth:(NSDateComponents*)month width:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, HFCalendarDayViewHeight)];
    if (self != nil) {
        // Initialise properties
        _month = [month copy];
        _dayViewsDictionary = [[NSMutableDictionary alloc] init];
        
        [self generateDayViews];
    }
    
    return self;
}


- (void)generateDayViews
{
    NSDateComponents *day = [[NSDateComponents alloc] init];
    day.calendar = self.month.calendar;
    day.day = 1;
    day.month = self.month.month;
    day.year = self.month.year;
    day.weekday = [[day.calendar dateFromComponents:day] weekdayOfDateInCalendar:self.month.calendar] - 1;
    
    NSInteger daysInMonth = [day.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[day date]].length;
    NSInteger firstDateColumn = day.weekday - day.calendar.firstWeekday;
    if (firstDateColumn < 0)
        firstDateColumn += daysPerWeek;
    
    dayViewWidths = @[@(42),@(43),@(43),@(43),@(43),@(43),@(43)];
    CGPoint nextDayViewOrigin = CGPointMake(10, HFCalendarDestinationLabelHeight);
    
    //previous month
    if (firstDateColumn > 0) {
        NSDateComponents *day = [[NSDateComponents alloc] init];
        day.calendar = self.month.calendar;
        if (self.month.month == 1) {
            day.month = 12;
            day.year = self.month.year - 1;
        }
        else
        {
            day.month = self.month.month - 1;
            day.year = self.month.year;
        }
        
        NSInteger daysInPreviousMonth = [day.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[day date]].length;

        for (int i = 0; i<firstDateColumn; i++) {
            day.day = (daysInPreviousMonth - firstDateColumn + i + 1);
            [self addSubview:[self setDayViewForOrigin:nextDayViewOrigin withIndex:i andDay:day andDayViewState:YXCalendarDayViewStateNotSelected isCurrentMonth:NO]];
            nextDayViewOrigin.x += [[dayViewWidths objectAtIndex:i] floatValue];
        }
    }

    NSInteger lastDayColumn = 0;
    while (day.month == self.month.month && day.day <= daysInMonth)
    {
        for (NSInteger c = firstDateColumn; c < daysPerWeek; c++) {
            if (day.month == self.month.month && day.day <= daysInMonth ) {
                lastDayColumn = c;
                [self addSubview: [self setDayViewForOrigin:nextDayViewOrigin withIndex:c andDay:day andDayViewState:YXCalendarDayViewStateNotSelected isCurrentMonth:YES]];
            }
            else
                break;
            
            day.day = day.day + 1;
            nextDayViewOrigin.x += [[dayViewWidths objectAtIndex:c] floatValue];
        }
        
        if (nextDayViewOrigin.x == 310 && day.day <= daysInMonth) {
            nextDayViewOrigin.x = 10;
            nextDayViewOrigin.y += HFCalendarDayViewHeight + HFCalendarDestinationLabelHeight;
            firstDateColumn = 0;
        }
    }

    //day views for next month
    if (lastDayColumn < 6) {
        NSDateComponents *day = [[NSDateComponents alloc] init];
        day.calendar = self.month.calendar;
        day.day = 1;
        if (self.month.month == 12) {
            day.month = 1;
            day.year = self.month.year + 1;
        }
        else
        {
            day.month = self.month.month + 1;
            day.year = self.month.year;
        }
        
        for (NSInteger j = lastDayColumn + 1; j < daysPerWeek; j++)
        {
            [self addSubview:[self setDayViewForOrigin:nextDayViewOrigin withIndex:j andDay:day andDayViewState:YXCalendarDayViewStateNotSelected isCurrentMonth:NO]];
            nextDayViewOrigin.x += [[dayViewWidths objectAtIndex:j] floatValue];
            day.day = day.day + 1;
        }
    }
    
    CGRect fullFrame = CGRectZero;
    fullFrame.size.height = nextDayViewOrigin.y + HFCalendarDayViewHeight;
    for (NSNumber *width in dayViewWidths) {
        fullFrame.size.width += width.floatValue;
    }
    self.frame = fullFrame;
    self.backgroundColor = [UIColor whiteColor];
}

- (YXCalendarDayView *)setDayViewForOrigin:(CGPoint)nextDayViewOrigin
                                 withIndex:(NSInteger)index
                                    andDay:(NSDateComponents *)day
                           andDayViewState:(YXCalendarDayViewState)dayViewState
                            isCurrentMonth:(BOOL)isCurrent
{
    YXCalendarDayView *dayView = [[YXCalendarDayView alloc] initWithFrame:[self getTheDayViewFrameBasedOnOrigin:nextDayViewOrigin andIndex:index]];
    dayView.dayViewState = dayViewState;
    dayView.inCurrentMonth = isCurrent;
    dayView.day = day;
    switch (index) {
        case 0:
            dayView.positionType = YXCalendarDayViewPositionFirst;
            break;
            
        case daysPerWeek - 1:
            dayView.positionType = YXCalendarDayViewPositionLast;
            break;
            
        default:
            dayView.positionType = YXCalendarDayViewMiddle;
            break;
    }
    [self.dayViewsDictionary setObject:dayView forKey:[self dayViewKeyForDay:day]];
    return dayView;
}

- (CGRect)getTheDayViewFrameBasedOnOrigin:(CGPoint)origin andIndex:(NSInteger)index
{
    CGRect dayFrame = CGRectZero;
    dayFrame.origin = origin;
    dayFrame.size.width = [[dayViewWidths objectAtIndex:index] floatValue];
    dayFrame.size.height = HFCalendarDayViewHeight;
    return dayFrame;
}

- (NSSet *)dayViews {
    return [NSSet setWithArray:self.dayViewsDictionary.allValues];
}

- (NSString *)dayViewKeyForDay:(NSDateComponents*)day {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    return [formatter stringFromDate:[day date]];
}

- (void)updateDaySelectionStatesForRange:(YXCalendarSelectRange*)range
{
    for (YXCalendarDayView *dayView in self.dayViews) {
        if ([range containsDate:dayView.dateForDay]) {
            BOOL isStartOfRange = [range.startDay isEqual:dayView.day];
            BOOL isEndOfRange = [range.endDay isEqual:dayView.day];
            
            if (isStartOfRange && isEndOfRange) {
                dayView.dayViewState = YXCalendarDayViewStateOneDay;
            }
            else if (isStartOfRange) {
                dayView.dayViewState = YXCalendarDayViewStateStartDay;
            }
            else if (isEndOfRange) {
                dayView.dayViewState = YXCalendarDayViewStateEndDay;
            }
            else {
                dayView.dayViewState = YXCalendarDayViewStateInBetween;
            }
        }
        else {
            dayView.dayViewState = YXCalendarDayViewStateNotSelected;
        }
    }
}

- (void)updateDaySelectionStatesForRanges:(NSMutableArray*)rangesArray andCurrentRange:(YXCalendarSelectRange*)range
{
    NSInteger index = [rangesArray indexOfObject:range] + 1;
    UIColor *backgroundColor = [HFGeneralHelpers getItineraryColorForIndex:index];
    range.rangeColor = backgroundColor;
    for (YXCalendarDayView *dayView in self.dayViews) {
        BOOL notSelected = NO;
        if ([range containsDate:dayView.dateForDay]) {
            BOOL isStartOfRange = [range.startDay isEqual:dayView.day];
            BOOL isEndOfRange = [range.endDay isEqual:dayView.day];
            dayView.backgroundColor = backgroundColor;

            if (isStartOfRange && isEndOfRange) {
                dayView.dayViewState = YXCalendarDayViewStateOneDay;
            }
            else if (isStartOfRange) {
                dayView.dayViewState = YXCalendarDayViewStateStartDay;
            }
            else if (isEndOfRange) {
                dayView.dayViewState = YXCalendarDayViewStateEndDay;
            }
            else {
                dayView.dayViewState = YXCalendarDayViewStateInBetween;
            }
            notSelected = YES;
        }
        else
        {
            for (YXCalendarSelectRange *r in rangesArray)
            {
                if (![r isEqual:range] && [r containsDate:dayView.dateForDay])
                {
                    notSelected = YES;
                    break;
                }
            }
        }
        
        if (!notSelected) {
            dayView.dayViewState = YXCalendarDayViewStateNotSelected;
        }
    }
}

- (void)updateAllDaySelectionStateForRanges:(NSMutableArray*)rangesArray
{
    for (YXCalendarSelectRange *r in rangesArray) {
        NSInteger index = [rangesArray indexOfObject:r] + 1;
        UIColor *backgroundColor;
        backgroundColor = r.rangeColor ?:[HFGeneralHelpers getItineraryColorForIndex:index];
        for (YXCalendarDayView *dayView in self.dayViews) {
            if ([r containsDate:dayView.dateForDay]) {
                BOOL isStartOfRange = [r.startDay isEqual:dayView.day];
                BOOL isEndOfRange = [r.endDay isEqual:dayView.day];
                dayView.backgroundColor = backgroundColor;
                
                if (isStartOfRange && isEndOfRange) {
                    dayView.dayViewState = YXCalendarDayViewStateOneDay;
                }
                else if (isStartOfRange) {
                    dayView.dayViewState = YXCalendarDayViewStateStartDay;
                }
                else if (isEndOfRange) {
                    dayView.dayViewState = YXCalendarDayViewStateEndDay;
                }
                else {
                    dayView.dayViewState = YXCalendarDayViewStateInBetween;
                }
            }
        }
    }
}

- (void)updateDaySelectionStatesForDeletedRange:(YXCalendarSelectRange *)range
{
    for (YXCalendarDayView *dayView in self.dayViews) {
        if ([range containsDate:dayView.dateForDay]) {
            dayView.dayViewState = YXCalendarDayViewStateNotSelected;
        }
    }
}

- (BOOL)isDate:(NSDateComponents *)date1 equaltoDate:(NSDateComponents *)date2
{
    if (date1.year == date2.year && date1.month == date2.month && date1.day == date2.day) {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
