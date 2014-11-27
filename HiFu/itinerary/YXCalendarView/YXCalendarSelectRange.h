//
//  YXCalendarSelectRange.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/12/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItineraryObject, CityObject;
@interface YXCalendarSelectRange : NSObject

@property (nonatomic, strong) NSDateComponents *startDay;
@property (nonatomic, strong) NSDateComponents *endDay;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSMutableArray *dayViewsArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) NSString *destinationId;
@property (nonatomic, strong) UIColor *rangeColor;
@property (nonatomic, strong) ItineraryObject *itinerary;
@property (nonatomic, strong) CityObject *city;

- (id)initWithStartDay:(NSDateComponents*)start endDay:(NSDateComponents*)end andIndex:(NSInteger)index;

- (BOOL)containsDay:(NSDateComponents*)day;
- (BOOL)containsDate:(NSDate*)date;

@end
