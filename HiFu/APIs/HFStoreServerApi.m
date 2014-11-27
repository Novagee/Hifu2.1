//
//  HFStoreServerApi.m
//  HiFu
//
//  Created by Peng Wan on 11/2/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFStoreServerApi.h"

@implementation HFStoreServerApi

+ (id)getStoresForLocation:(CLLocation *)location
                 pageNumber:(int)pageNumber
              couponPerPage:(int)perPage
                    success:(void (^)(id coupons))successBlock
                    failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/store/all", HF_API_PATH_v2];
    NSDictionary *params;
    params = @{
               @"lat": location? @(location.coordinate.latitude): @"",
               @"lon" : location ? @(location.coordinate.longitude): @"",
               @"page": @(pageNumber),
               @"per_page" : @(perPage)};
    NSLog(@"param:%@",params);
    return [[HFBaseAPIv2 sharedInstance] HFRequestGETWithURL:path
                                                parameters:params
                                                   success:^(id responseObject) {
                                                       successBlock([responseObject objectForKey:@"data"]);
                                                   } failure:^(NSError *error) {
                                                       failureBlock(error);
                                                   }];
}

+ (id)getStoresForCity:(int)cityId
            forLocation:(CLLocation *)location
            pageNumber:(int)pageNumber
         couponPerPage:(int)perPage
               success:(void (^)(id stores))successBlock
               failure:(void (^)(NSError * error))failureBlock{
    NSString *path = [NSString stringWithFormat:@"%@/store/city/%i", HF_API_PATH_v2, cityId];
    NSDictionary *params;
    params = @{
               @"lat": location? @(location.coordinate.latitude): @"",
               @"lon" : location ? @(location.coordinate.longitude): @"",
               @"page": @(pageNumber),
               @"per_page" : @(perPage)};
    NSLog(@"param:%@",params);
    return [[HFBaseAPIv2 sharedInstance] HFRequestGETWithURL:path
                                                  parameters:params
                                                     success:^(id responseObject) {
                                                         successBlock([responseObject objectForKey:@"data"]);
                                                     } failure:^(NSError *error) {
                                                         failureBlock(error);
                                                     }];
}


@end
