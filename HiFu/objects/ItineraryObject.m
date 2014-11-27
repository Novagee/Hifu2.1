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
        if([dictionary objectForKey:@"startDate"] && [dictionary objectForKey:@"startDate"] != [NSNull null])
            self.startDate = [df dateFromString:[dictionary objectForKey:@"startDate"]];
        
        if([dictionary objectForKey:@"endDate"] && [dictionary objectForKey:@"endDate"] != [NSNull null])
            self.endDate = [df dateFromString:[dictionary objectForKey:@"endDate"]];
    }
    return self;
}

@end
