//
//  CityServerApi.h
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityServerApi : NSObject

+ (NSArray *)getCities;

+ (id)getServerCitiesSuccess:(void (^)(id coupons))successBlock
                     failure:(void (^)(NSError * error))failureBlock;

@end
