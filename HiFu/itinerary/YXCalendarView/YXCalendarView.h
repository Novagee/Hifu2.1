//
//  YXCalendarView.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXCalendarHeaderView, YXCalendarMonthView, YXCalendarSelectRange;

@protocol YXCalendarViewDelegate;

@interface YXCalendarView : UIView

@property (nonatomic, weak) id<YXCalendarViewDelegate>delegate;
@property (nonatomic, strong) YXCalendarHeaderView *calendarHeaderView;
@property (nonatomic, strong) NSDateComponents *currentMonth;
@property (nonatomic, strong) YXCalendarMonthView *monthViewOne;//using 2 different calendar month view for the fade-in fade-out animation when switch monthes
@property (nonatomic, strong) YXCalendarMonthView *monthViewTwo;
@property (nonatomic, assign) BOOL isMonthViewTwoShow;
@property (nonatomic, strong) NSMutableArray *rangesArray;
@property (nonatomic, strong) NSArray *sortedArray;

- (IBAction)lastMonthButtonClicked:(id)sender;
- (IBAction)nextMonthButtonClicked:(id)sender;
- (void)sortAllRanages;
- (void)updateAllDaySelectionStateForRanges;

@end

@protocol YXCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(YXCalendarView *)calendarView didSelectRange:(YXCalendarSelectRange *)range;
- (void)calendarView:(YXCalendarView *)calendarView didSelectRange:(YXCalendarSelectRange *)range withLastTouchedViewOrigin:(CGPoint)touchedViewOrigin;
- (void)calendarView:(YXCalendarView *)calendarView andMonthView:(YXCalendarMonthView *)monthView willChangeToVisibleMonth:(NSDateComponents*)month duration:(NSTimeInterval)duration;
- (void)calendarView:(YXCalendarView *)calendarView andMonthView:(YXCalendarMonthView *)monthView didChangeToVisibleMonth:(NSDateComponents*)month;
- (YXCalendarView *)calendarView:(YXCalendarView *)calendarView didDragToDay:(NSDateComponents*)day selectingRange:(YXCalendarSelectRange *)range;
- (BOOL)calendarView:(YXCalendarView *)calendarView shouldAnimateDragToMonth:(NSDateComponents*)month;

@end

