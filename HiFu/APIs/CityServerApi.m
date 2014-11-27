//
//  CityServerApi.m
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "CityServerApi.h"
#import "CityObject.h"

@implementation CityServerApi

+ (NSArray *)getCities
{
    //this is a fake api call, since we saved all city data locally
    //but eventually this should come from api
    NSMutableArray *citiesArray = [NSMutableArray new];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"CityList.plist"];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
    }
    
    NSArray *cityList= [[NSArray alloc] initWithContentsOfFile: path];
    if (cityList)
    {
        for (NSDictionary *dict in cityList) {
            CityObject *city = [[CityObject alloc] initWithDictionary:dict];
            [citiesArray addObject:city];
        }
    }
    
    return citiesArray;
}


@end
