//
//  YXCalendarView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarView.h"
#import "YXCalendarHeaderView.h"
#import "YXCalendarMonthView.h"
#import "YXCalendarDayView.h"
#import "YXCalendarSelectRange.h"
#import "UserServerApi.h"
#import <Appsee/Appsee.h>

@implementation YXCalendarView
{
    YXCalendarSelectRange *currentDraggingRange, *currentSelectedRange;
    NSDateComponents *draggingDay, *rangeEndDay;
    CGPoint lastTouchedDayViewOrigin;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //initial the calendar header view
    self.calendarHeaderView = [YXCalendarHeaderView sharedInstance];
    self.rangesArray = [NSMutableArray new];
    self.calendarHeaderView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, HFCalendarHeaderViewHeight);
    [self insertSubview:self.calendarHeaderView atIndex:999];
    //add target to the next/previous button of header view
    [self.calendarHeaderView.lastMonthButton addTarget:self action:@selector(lastMonthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarHeaderView.nextMonthButton addTarget:self action:@selector(nextMonthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.currentMonth = [[NSCalendar currentCalendar] components:NSYearCalendarUnit |
                                                                 NSMonthCalendarUnit |
                                                                 NSDayCalendarUnit |
                                                                 NSWeekdayCalendarUnit |
                                                                 NSCalendarCalendarUnit
                                                        fromDate:[NSDate date]];
    self.currentMonth.day = 1;
    
    [self updateMonthLabelMonth:self.currentMonth];
    self.monthViewOne =  [[YXCalendarMonthView alloc] initWithMonth:self.currentMonth width:self.bounds.size.width];
    self.monthViewOne.frame = CGRectMake(0,
                                         self.calendarHeaderView.frame.origin.y + self.calendarHeaderView.frame.size.height,
                                         self.bounds.size.width,
                                         self.monthViewOne.frame.size.height);
    [self insertSubview:self.monthViewOne belowSubview:self.calendarHeaderView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRange:) name:HFCalDeleteRange object:nil];
}


#pragma mark - Actions
- (IBAction)lastMonthButtonClicked:(id)sender
{
    NSDateComponents *newMonth = self.currentMonth;
    newMonth.month--;
    self.calendarHeaderView.lastMonthButton.userInteractionEnabled = NO;
    [self setVisibleMonth:newMonth animated:YES];
}

- (IBAction)nextMonthButtonClicked:(id)sender
{
    NSDateComponents *newMonth = self.currentMonth;
    newMonth.month++;
    self.calendarHeaderView.nextMonthButton.userInteractionEnabled = NO;
    [self setVisibleMonth:newMonth animated:YES];
}

#pragma mark - Helpers
- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY年 MM月";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.calendarHeaderView.monthLabel.text = [formatter stringFromDate:date];
}

- (void)setVisibleMonth:(NSDateComponents *)visibleMonth animated:(BOOL)animated {
    if (!self.isMonthViewTwoShow) {
        self.monthViewTwo = [[YXCalendarMonthView alloc] initWithMonth:visibleMonth width:self.bounds.size.width];
        self.monthViewTwo.frame = CGRectMake(self.monthViewOne.frame.origin.x,
                                             self.monthViewOne.frame.origin.y,
                                             self.monthViewTwo.frame.size.width,
                                             self.monthViewTwo.frame.size.height);
        [self insertSubview:self.monthViewTwo belowSubview:self.calendarHeaderView];
        self.monthViewTwo.alpha = 0;
        self.calendarHeaderView.backgroundColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.monthViewOne.alpha = 0;
            self.monthViewTwo.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.monthViewOne removeFromSuperview];
            self.monthViewOne = nil;
            self.calendarHeaderView.lastMonthButton.userInteractionEnabled = YES;
            self.calendarHeaderView.nextMonthButton.userInteractionEnabled = YES;
        }];
        [self.monthViewTwo updateAllDaySelectionStateForRanges:self.rangesArray];
    }
    else
    {
        self.monthViewOne = [[YXCalendarMonthView alloc] initWithMonth:visibleMonth width:self.bounds.size.width];
        self.monthViewOne.frame = CGRectMake(self.monthViewTwo.frame.origin.x,
                                             self.monthViewTwo.frame.origin.y,
                                             self.monthViewOne.frame.size.width,
                                             self.monthViewOne.frame.size.height);
        [self insertSubview:self.monthViewOne belowSubview:self.calendarHeaderView];
        self.monthViewOne.alpha = 0;
        self.calendarHeaderView.backgroundColor = [UIColor whiteColor];

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.monthViewTwo.alpha = 0;
            self.monthViewOne.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.monthViewTwo removeFromSuperview];
            self.monthViewTwo = nil;
            self.calendarHeaderView.lastMonthButton.userInteractionEnabled = YES;
            self.calendarHeaderView.nextMonthButton.userInteractionEnabled = YES;
        }];
        [self.monthViewOne updateAllDaySelectionStateForRanges:self.rangesArray];
    }
   
    [self updateMonthLabelMonth:self.currentMonth];
    self.isMonthViewTwoShow = !self.isMonthViewTwoShow;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:andMonthView:didChangeToVisibleMonth:)])
    {
        [self.delegate calendarView:self andMonthView:self.isMonthViewTwoShow ? self.monthViewTwo : self.monthViewOne didChangeToVisibleMonth:visibleMonth];
    }
}

- (BOOL)monthStartsOnFirstDayOfWeek:(NSDateComponents*)month {
    // Make sure we have the components we need to do the calculation
    month = [month.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:month.date];
    
    return (month.weekday - month.calendar.firstWeekday == 0);
}


#pragma mark - Touch Relate
- (YXCalendarDayView *)dayViewForTouches:(NSSet*)touches {
    if (touches.count != 1) {
        return nil;
    }
    
    UITouch *touch = [touches anyObject];
    
    // Work out which day view was touched. We can't just use hit test on a root view because the month views can overlap
    UIView *view = [self hitTest:[touch locationInView:self] withEvent:nil];
    if ([view isKindOfClass:[YXCalendarDayView class]]) {
        return (YXCalendarDayView*)view;
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    draggingDay = nil;
    currentDraggingRange = nil;
    currentSelectedRange = nil;
    lastTouchedDayViewOrigin = CGPointZero;
    YXCalendarDayView *touchedView = [self dayViewForTouches:touches];
    if (touchedView == nil) {
        return;
    }
    else
    {
        
        lastTouchedDayViewOrigin = touchedView.frame.origin;
        //check if we have any existing range
        if ([self.rangesArray count] == 0) {
            YXCalendarSelectRange *range = [[YXCalendarSelectRange alloc] initWithStartDay:touchedView.day endDay:touchedView.day andIndex:0];
            [Appsee addEvent:@"Calendar Range Selected" withProperties:@{@"userId":[UserServerApi sharedInstance].currentUserId,@"startDay":range.startDate,@"endDate":range.endDate}];
            [range.dayViewsArray addObject:touchedView];
            [self.rangesArray addObject:range];
            draggingDay = range.startDay;
            currentDraggingRange = range;
            [self updateViewForRange:range];
        }
        else
        {
            //if we have exisiting range, find out if user is touching any of the start day or end day
            for (YXCalendarSelectRange *r in self.rangesArray) {
                if ([r.startDay isEqual:touchedView.day]) {
                    draggingDay = r.endDay;
                    rangeEndDay = r.startDay;
                    currentDraggingRange = r;
                    break;
                }
                else if ([r.endDay isEqual:touchedView.day]) {
                    draggingDay = r.startDay;
                    rangeEndDay = r.endDay;
                    currentDraggingRange = r;
                    break;
                }
                else if([r containsDate:touchedView.dateForDay])
                {
                    currentSelectedRange =r; //touch a date in that range
                }
            }
            
            //if none of the existing range is dragged or selected
            if (!currentDraggingRange && !currentSelectedRange) {
                YXCalendarSelectRange *range = [[YXCalendarSelectRange alloc] initWithStartDay:touchedView.day endDay:touchedView.day andIndex:[self.rangesArray count]];
                [Appsee addEvent:@"Calendar Range Selected" withProperties:@{@"userId":[UserServerApi sharedInstance].currentUserId,@"startDay":range.startDate,@"endDate":range.endDate}];
                [self.rangesArray addObject:range];
                [range.dayViewsArray addObject:touchedView];
                draggingDay = range.startDay;
                currentDraggingRange = range;
                [self updateViewForRange:range];
            }
            
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (draggingDay == nil || currentDraggingRange == nil) {
        //Don't know which one is dragging
        return;
    }
    
    YXCalendarDayView *touchedView = [self dayViewForTouches:touches];
    if (touchedView == nil) {
        //Not Day is touched in Touches Moved
        return;
    }

    lastTouchedDayViewOrigin = touchedView.frame.origin;
    if ([touchedView.day.date compare:draggingDay.date] == NSOrderedAscending)
    {
        [self updateCollapsedRangeForTouchView:touchedView forAscending:YES];
        currentDraggingRange.startDay = touchedView.day;
        currentDraggingRange.startDate = [touchedView.day date];
        for (YXCalendarDayView *dv in self.monthViewOne.dayViews) {
            if (dv.day.day >= touchedView.day.day && dv.day.day < currentDraggingRange.endDay.day && ![currentDraggingRange.dayViewsArray containsObject:dv]) {
                [currentDraggingRange.dayViewsArray addObject:dv];

            }
        }
        [self updateViewForRange:currentDraggingRange];
    }
    else if([touchedView.day.date compare:draggingDay.date] == NSOrderedDescending)
    {
        [self updateCollapsedRangeForTouchView:touchedView forAscending:NO];
        currentDraggingRange.endDay = touchedView.day;
        currentDraggingRange.endDate = [touchedView.day date];
        for (YXCalendarDayView *dv in self.monthViewOne.dayViews) {
            if (dv.day.day <= touchedView.day.day && dv.day.day > currentDraggingRange.startDay.day && ![currentDraggingRange.dayViewsArray containsObject:dv]) {
                [currentDraggingRange.dayViewsArray addObject:dv];
                
            }
        }
        if(![currentDraggingRange.dayViewsArray containsObject:touchedView])
            [currentDraggingRange.dayViewsArray addObject:touchedView];
        [self updateViewForRange:currentDraggingRange];
    }
    else
    {
        currentDraggingRange.startDay = touchedView.day;
        currentDraggingRange.startDate = [touchedView.day date];
        currentDraggingRange.endDay = touchedView.day;
        currentDraggingRange.endDate = [touchedView.day date];
        [currentDraggingRange.dayViewsArray removeAllObjects];
        if(![currentDraggingRange.dayViewsArray containsObject:touchedView])
            [currentDraggingRange.dayViewsArray addObject:touchedView];
        [self updateViewForRange:currentDraggingRange];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (currentSelectedRange) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectRange:withLastTouchedViewOrigin:)]) {
            [self.delegate calendarView:self didSelectRange:currentSelectedRange withLastTouchedViewOrigin:CGPointMake(lastTouchedDayViewOrigin.x,
                                                                                                                       lastTouchedDayViewOrigin.y + HFCalendarDayViewHeight + 5 + HFCalendarHeaderViewHeight)];
        }
    }
    
    if (draggingDay == nil || currentDraggingRange == nil) {
        //Don't know which one is dragging
        return;
    }
 
    //sort all the ranges based on the end date
    [self sortAllRanages];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectRange:withLastTouchedViewOrigin:)]) {
        [self.delegate calendarView:self didSelectRange:currentDraggingRange withLastTouchedViewOrigin:CGPointMake(lastTouchedDayViewOrigin.x,
                                                                                                                   lastTouchedDayViewOrigin.y + HFCalendarDayViewHeight + 5 + HFCalendarHeaderViewHeight)];
    }
    YXCalendarDayView *touchedView = [self dayViewForTouches:touches];
    if (touchedView == nil) {
        //Not Day is touched in Touches Ended
        return;
    }
  
    [self updateViewForRange:currentDraggingRange];
}

- (void)updateCollapsedRangeForTouchView: (YXCalendarDayView *)touchedView forAscending:(BOOL)isAscending
{
    YXCalendarSelectRange *updateRange;
    for (YXCalendarSelectRange *r in self.rangesArray) {
        if ([r containsDate:touchedView.dateForDay]) {
            updateRange = r;
            break;
        }
    }
    
    if (updateRange && ![updateRange isEqual:currentDraggingRange] && [updateRange containsDate:touchedView.dateForDay]) {
        
        NSMutableArray *viewArrayCopy = [updateRange.dayViewsArray mutableCopy];
        for (YXCalendarDayView *dv in viewArrayCopy) {
            if (isAscending && dv.day.day > touchedView.day.day - 1)
                [updateRange.dayViewsArray removeObject:dv];
            else if (!isAscending && dv.day.day < touchedView.day.day + 1)
                [updateRange.dayViewsArray removeObject:dv];
        }
        
        if ([updateRange.dayViewsArray count] > 0) {
            YXCalendarDayView *touchViewPreviousDay;
            for (YXCalendarDayView *dv in updateRange.dayViewsArray) {
                if (isAscending && dv.day.day == touchedView.day.day - 1)
                {
                    touchViewPreviousDay = dv;
                    break;
                }
                else if (!isAscending && dv.day.day == touchedView.day.day + 1)
                {
                    touchViewPreviousDay = dv;
                    break;
                }
            }
            
            if (isAscending) {
                updateRange.endDay = touchViewPreviousDay.day;
                updateRange.endDate = touchViewPreviousDay.day.date;
            }
            else
            {
                updateRange.startDay = touchViewPreviousDay.day;
                updateRange.startDate = touchViewPreviousDay.day.date;
            }
            
            [self updateViewForRange:updateRange];
            
        }
        else
        {
            [self.rangesArray removeObject:updateRange];
        }
    }
}

- (void)updateViewForRange:(YXCalendarSelectRange *)range
{
    if (!self.isMonthViewTwoShow) {
        [self.monthViewOne updateDaySelectionStatesForRanges:self.rangesArray andCurrentRange:range];
    }
    else
    {
        [self.monthViewTwo updateDaySelectionStatesForRanges:self.rangesArray andCurrentRange:range];
    }
}

- (void)sortAllRanages
{
    //sort all the ranges based on end date acending
    self.sortedArray = [self.rangesArray sortedArrayUsingComparator:^NSComparisonResult(YXCalendarSelectRange *rangeA, YXCalendarSelectRange *rangeB) {
        NSDate *first = rangeA.endDate;
        NSDate *second = rangeB.endDate;
        return [first compare:second];
    }];
}

- (void)updateAllDaySelectionStateForRanges
{
    if (!self.isMonthViewTwoShow) {
        [self.monthViewOne updateAllDaySelectionStateForRanges:self.rangesArray];
    }
    else
    {
        [self.monthViewTwo updateAllDaySelectionStateForRanges:self.rangesArray];
    }

}

- (void)deleteRange:(NSNotification *)notification
{
    YXCalendarSelectRange *range = notification.object;
    if (self.isMonthViewTwoShow) {
        [self.monthViewTwo updateDaySelectionStatesForDeletedRange:range];
    }
    else
    {
        [self.monthViewOne updateDaySelectionStatesForDeletedRange:range];
    }
    [self.rangesArray removeObject:range];
    [self sortAllRanages];
}

@end
