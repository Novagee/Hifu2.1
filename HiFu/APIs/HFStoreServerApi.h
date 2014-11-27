//
//  HFStoreServerApi.h
//  HiFu
//
//  Created by Peng Wan on 11/2/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFBaseAPIv2.h"
#import <CoreLocation/CoreLocation.h>

@interface HFStoreServerApi : HFBaseAPIv2

+ (id)getStoresForLocation:(CLLocation *)location
                 pageNumber:(int)pageNumber
              couponPerPage:(int)perPage
                    success:(void (^)(id stores))successBlock
                    failure:(void (^)(NSError * error))failureBlock;

+ (id)getStoresForCity:(int)cityId
                forLocation:(CLLocation *)location
                pageNumber:(int)pageNumber
             couponPerPage:(int)perPage
                   success:(void (^)(id stores))successBlock
                   failure:(void (^)(NSError * error))failureBlock;

@end
