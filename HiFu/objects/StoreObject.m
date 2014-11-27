//
//  StoreObject.m
//  HiFu
//
//  Created by Yin Xu on 8/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "StoreObject.h"
#import "WorkHourObject.h"

@implementation StoreObject

+(Class)dayWorkHours_type {
    return [WorkHourObject class];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{

    self = [super initWithDictionary:dictionary];
    if (self)
    {
        if([dictionary objectForKey:@"id"] && [dictionary objectForKey:@"id"] != [NSNull null])
            self.storeId = [dictionary objectForKey:@"id"];
    }
    return self;
}

@end
