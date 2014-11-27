//
//  YXCalendarMonthView.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarSelectRange.h"

@interface YXCalendarMonthView : UIView

@property (nonatomic, copy) NSDateComponents *month;
@property (nonatomic, strong, readonly) NSSet *dayViews;
@property (nonatomic, strong) NSMutableDictionary *dayViewsDictionary;

- (id)initWithMonth:(NSDateComponents*)month width:(CGFloat)width;
- (void)updateDaySelectionStatesForRange:(YXCalendarSelectRange*)range;
- (void)updateDaySelectionStatesForRanges:(NSMutableArray*)rangesArray andCurrentRange:(YXCalendarSelectRange*)range;
- (void)updateAllDaySelectionStateForRanges:(NSMutableArray*)rangesArray;
- (void)updateDaySelectionStatesForDeletedRange:(YXCalendarSelectRange *)range;

@end
