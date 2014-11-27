//
//  CouponServerApi.m
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "CouponServerApi.h"
#import "HFBaseApi.h"

@implementation CouponServerApi

+ (id)getCouponsForLocation:(CLLocation *)location
                 pageNumber:(int)pageNumber
              couponPerPage:(int)perPage
                    success:(void (^)(id coupons))successBlock
                    failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/coupon/new/", HF_API_PATH];
    NSDictionary *params;
    params = @{@"latitude": location? @(location.coordinate.latitude): @"", @"longitude" : location ? @(location.coordinate.longitude): @"", @"page": @(pageNumber), @"per_page" : @(perPage)};
    
    return [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                                parameters:params
                                                   success:^(id responseObject) {
                                                       successBlock([responseObject objectForKey:@"returnedCoupons"]);
                                                   } failure:^(NSError *error) {
                                                       failureBlock(error);
                                                   }];
}

+ (id)getFavoriteCouponsForUser:(NSString *)userId
                        success:(void (^)(id coupons))successBlock
                        failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/coupon/all/favorite/%@", HF_API_PATH, userId];
    return [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                                parameters:nil
                                                   success:^(id responseObject) {
                                                       successBlock([responseObject objectForKey:@"returnedCoupons"]);
                                                   } failure:^(NSError *error) {
                                                       failureBlock(error);
                                                   }];
}

+ (id)addFavoriteCoupon:(NSString *)couponId
                forUser:(NSString *)userId
                success:(void (^)())successBlock
                failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/coupon/favorite/%@/%@", HF_API_PATH, userId,couponId];
    return [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:path
                                                 parameters:nil
                                                    success:^(id responseObject) {
                                                        successBlock();
                                                    } failure:^(NSError *error) {
                                                        failureBlock(error);
                                                    }];
}

+ (id)removeFavoriteCoupon:(NSString *)couponId
                   forUser:(NSString *)userId
                   success:(void (^)())successBlock
                   failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/coupon/favorite/%@/%@", HF_API_PATH, userId,couponId];
    return [[HFBaseApi sharedInstance] HFRequestDELETEWithURL:path
                                                   parameters:nil
                                                      success:^(id responseObject) {
                                                          successBlock();
                                                      } failure:^(NSError *error) {
                                                          failureBlock(error);
                                                      }];
}

@end
