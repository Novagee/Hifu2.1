//
//  EasyData.m
//  HiFu
//
//  Created by Rich on 6/5/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "EasyData.h"

@implementation EasyData

+(id)getDataWithKey:(id)key{
    id retString;
    
    if ((id)[[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        
        retString = (id)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return retString;
}

+(void)setData:(id)data forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:key];
}

@end
