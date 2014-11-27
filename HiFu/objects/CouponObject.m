//
//  CouponObject.m
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "CouponObject.h"

@implementation CouponObject

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
        
        if([dictionary objectForKey:@"id"] && [dictionary objectForKey:@"id"] != [NSNull null])
            self.couponId = [dictionary objectForKey:@"id"];
        
        if([dictionary objectForKey:@"description"] && [dictionary objectForKey:@"description"] != [NSNull null])
            self.descriptionEN = [dictionary objectForKey:@"description"];
        
        if([dictionary objectForKey:@"createdAt"] && [dictionary objectForKey:@"createdAt"] != [NSNull null])
            self.createdAt = [df dateFromString:[dictionary objectForKey:@"createdAt"]];
        
        if([dictionary objectForKey:@"updatedAt"] && [dictionary objectForKey:@"updatedAt"] != [NSNull null])
            self.updatedAt = [df dateFromString:[dictionary objectForKey:@"updatedAt"]];
        
        if([dictionary objectForKey:@"expiredAt"] && [dictionary objectForKey:@"expiredAt"] != [NSNull null])
            self.expiredAt = [df dateFromString:[dictionary objectForKey:@"expiredAt"]];
    }
    return self;
}


@end
