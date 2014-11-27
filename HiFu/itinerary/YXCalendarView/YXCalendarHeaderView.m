//
//  YXCalendarHeaderView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXCalendarHeaderView.h"

@implementation YXCalendarHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)sharedInstance
{
    static YXCalendarHeaderView *header = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        header = [[UINib nibWithNibName:@"YXCalendarHeaderView" bundle:nil] instantiateWithOwner:nil options:NULL][0];
    });
    
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarCalendarUnit |
                                                                                NSYearCalendarUnit |
                                                                                NSMonthCalendarUnit |
                                                                                NSDayCalendarUnit |
                                                                                NSWeekdayCalendarUnit
                                                                       fromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EE";    
    for (NSInteger i = 0; i < 7; i++) {
        NSInteger weekday = dateComponents.weekday - [dateComponents.calendar firstWeekday];
        if (weekday < 0) weekday += 7;
        dateComponents.day = dateComponents.day + 1;
        dateComponents = [dateComponents.calendar components:NSCalendarCalendarUnit |
                                                                NSYearCalendarUnit |
                                                                NSMonthCalendarUnit |
                                                                NSDayCalendarUnit |
                                                                NSWeekdayCalendarUnit
                                                    fromDate:dateComponents.date];
    }
}


@end
