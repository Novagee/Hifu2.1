//
//  itineraryObject.m
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "ItineraryObject.h"

@implementation ItineraryObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    static NSDateFormatter *df;
    
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        if (!df)
        {
            df = [[NSDateFormatter alloc] init];
//            df.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [df setDateFormat:@"yyyy-MM-dd"];
            
        }
        if([dictionary objectForKey:@"startDate"] && [dictionary objectForKey:@"startDate"] != [NSNull null]){
//            self.startDate = [df dateFromString:[dictionary objectForKey:@"startDate"]];
            double d = [[dictionary objectForKey:@"startDate"] doubleValue];
            self.startDate = [NSDate dateWithTimeIntervalSince1970:d];
        }
        if([dictionary objectForKey:@"endDate"] && [dictionary objectForKey:@"endDate"] != [NSNull null]){
//            self.endDate = [df dateFromString:[dictionary objectForKey:@"endDate"]];
            double  d = [[dictionary objectForKey:@"endDate"] doubleValue];
            self.endDate = [NSDate dateWithTimeIntervalSince1970:d];
        }
    }
    return self;
}

@end
