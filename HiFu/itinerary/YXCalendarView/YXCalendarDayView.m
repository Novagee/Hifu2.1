//
//  YXCalendarDayView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarDayView.h"
#import "NSDate+YXCalendarViewHelper.h"

@implementation YXCalendarDayView
{
    NSCalendar *calendar;
    NSString *dayText;
    __strong NSDateComponents *_day;
    __strong NSDate *_dayAsDate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark Custom Setter & Getter

- (void)setDayViewState:(YXCalendarDayViewState)dayViewState {
    _dayViewState = dayViewState;
    [self setNeedsDisplay];
}

- (void)setDay:(NSDateComponents *)aDay {
    calendar = [aDay calendar];
    _dateForDay = [aDay date];
    _day = nil;
    dayText = [NSString stringWithFormat:@"%ld", (long)aDay.day];
}

- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [self.dateForDay dayOfCalendar:calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
}



//- (void)setInCurrentMonth:(BOOL)inCurrentMonth {
//    self.inCurrentMonth = inCurrentMonth;
//    [self setNeedsDisplay];
//}

#pragma mark - Draw View
- (void)drawRect:(CGRect)rect {
    [self drawBackground];
    [self drawDayNumber];
    [self drawCornerRadius];
}

- (void)drawBackground
{    
    switch (self.dayViewState) {
        case YXCalendarDayViewStateNotSelected:
            [[UIColor whiteColor] setFill];
            UIRectFill(self.bounds);
            break;
        case YXCalendarDayViewStateStartDay:
            [self.backgroundColor setFill];
            UIRectFill(self.bounds);
            break;
        case YXCalendarDayViewStateEndDay:
            [self.backgroundColor setFill];
            UIRectFill(self.bounds);
            break;
        case YXCalendarDayViewStateInBetween:
            [self.backgroundColor setFill];
            UIRectFill(self.bounds);
            break;
        case YXCalendarDayViewStateOneDay:
            [self.backgroundColor setFill];
            UIRectFill(self.bounds);
            break;
        default:
            break;
    }
}

- (void)drawDayNumber {
    UIColor *textColor;
    switch (self.dayViewState) {
        case YXCalendarDayViewStateNotSelected:
            textColor = self.inCurrentMonth ? HFCDayNotSelectedTextColorCurrentMonth : HFCDayNotSelectedTextColorNonCurrentMonth;
            break;
        default:
            textColor = HFCDaySelectedTextColor ;
            break;
    }
    
    CGSize textSize = [dayText sizeWithAttributes:@{NSFontAttributeName:HelveticaNeue_Regular(14)}];
    CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)),
                                 ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)),
                                 textSize.width,
                                 textSize.height);
    [dayText drawInRect:textRect withAttributes:@{NSFontAttributeName:HelveticaNeue_Regular(14), NSForegroundColorAttributeName:textColor}];
}

- (void)drawCornerRadius
{
    switch (self.dayViewState) {
        case YXCalendarDayViewStateNotSelected:
            [self addRoundedCorners:UIRectCornerTopLeft |UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                          withRadii:CGSizeMake(0.0f, 0.0f)];
            break;
        case YXCalendarDayViewStateStartDay:
            [self addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
                          withRadii:CGSizeMake(4.0f, 4.0f)];
            break;
        case YXCalendarDayViewStateEndDay:
            [self addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                          withRadii:CGSizeMake(4.0f, 4.0f)];
            break;
        case YXCalendarDayViewStateInBetween:
            [self addRoundedCorners:UIRectCornerTopLeft |UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                          withRadii:CGSizeMake(0.0f, 0.0f)];
            break;
        case YXCalendarDayViewStateOneDay:
            [self addRoundedCorners:UIRectCornerTopLeft |UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                          withRadii:CGSizeMake(4.0f, 4.0f)];
            break;
        default:
            break;
    }
}

-(void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CALayer *tMaskLayer = [self maskForRoundedCorners:corners withRadii:radii];
    self.layer.mask = tMaskLayer;
}

-(CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:
                                 maskLayer.bounds byRoundingCorners:corners cornerRadii:radii];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    maskLayer.path = [roundedPath CGPath];
    
    return maskLayer;
}


@end
