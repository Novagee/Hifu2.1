//
//  UserObject.m
//  HiFu
//
//  Created by Rich on 6/30/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "UserObject.h"
#import "EasyData.h"

@implementation UserObject


-(id)initWithDictionary:(NSDictionary *)dictionary
{
   // dictionary = [NetResults resultsDeNull:dictionary];
    
     self = [super initWithDictionary:dictionary];
    
    [EasyData setData:[self dictionary]
               forKey:@"UserInfo"];
    if (self)
    {
        //Do Stuff
        if([dictionary objectForKey:@"id"] && [dictionary objectForKey:@"id"] != [NSNull null])
            self.itemId = [dictionary objectForKey:@"id"];
    }
    return self;
}



@end
