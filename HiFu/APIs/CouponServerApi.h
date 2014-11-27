//
//  CouponServerApi.h
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CouponServerApi : NSObject

+ (id)getCouponsForLocation:(CLLocation *)location
                   pageNumber:(int)pageNumber
                couponPerPage:(int)perPage
                      success:(void (^)(id coupons))successBlock
                      failure:(void (^)(NSError * error))failureBlock;

+ (id)getFavoriteCouponsForUser:(NSString *)userId
                          success:(void (^)(id coupons))successBlock
                          failure:(void (^)(NSError * error))failureBlock;

+ (id)addFavoriteCoupon:(NSString *)couponId
                  forUser:(NSString *)userId
                  success:(void (^)())successBlock
                  failure:(void (^)(NSError * error))failureBlock;

+ (id)removeFavoriteCoupon:(NSString *)couponId
                     forUser:(NSString *)userId
                     success:(void (^)())successBlock
                     failure:(void (^)(NSError * error))failureBlock;

@end
