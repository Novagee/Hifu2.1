//
//  HFOpenCoupon.m
//  HiFu
//
//  Created by Peng Wan on 11/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFOpenCoupon.h"

@implementation HFOpenCoupon

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        if([dictionary objectForKey:@"id"] && [dictionary objectForKey:@"id"] != [NSNull null])
            self.couponId = [dictionary objectForKey:@"id"];
    }
    return self;
}

@end
