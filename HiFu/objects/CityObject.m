//
//  cityObject.m
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "CityObject.h"

@implementation CityObject

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    // dictionary = [NetResults resultsDeNull:dictionary];
    
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        //Do Stuff
        if([dictionary objectForKey:@"name"] && [dictionary objectForKey:@"name"] != [NSNull null])
            self.nameUS = [dictionary objectForKey:@"name"];
        if([dictionary objectForKey:@"id"] && [dictionary objectForKey:@"id"] != [NSNull null])
            self.itemId = [dictionary objectForKey:@"id"];
        if([dictionary objectForKey:@"state"] && [dictionary objectForKey:@"state"] != [NSNull null])
            self.stateUS = [dictionary objectForKey:@"state"];
        if([dictionary objectForKey:@"zipCode"] && [dictionary objectForKey:@"zipCode"] != [NSNull null])
            self.zipcode = [dictionary objectForKey:@"zipCode"];
    }
    return self;
}

@end
