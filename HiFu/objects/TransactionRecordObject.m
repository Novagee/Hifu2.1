//
//  TransactionRecordObject.m
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "TransactionRecordObject.h"

@implementation TransactionRecordObject

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
        if([dictionary objectForKey:@"transactionTime"] && [dictionary objectForKey:@"transactionTime"] != [NSNull null])
            self.transactionTime = [df dateFromString:[dictionary objectForKey:@"transactionTime"]];
    }
    return self;
}

@end
