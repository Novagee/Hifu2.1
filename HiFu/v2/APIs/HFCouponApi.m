//
//  HFCouponApi.m
//  HiFu
//
//  Created by Peng Wan on 11/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponApi.h"

@implementation HFCouponApi

+ (id)getCouponsByPageNumber:(int)pageNumber
               couponPerPage:(int)perPage
                     success:(void (^)(id coupons))successBlock
                     failure:(void (^)(NSError * error))failureBlock
{
    
    //e.g http://54.183.40.21:8080/v2/offer/all?page=1&per_page=10
    NSString *path = [NSString stringWithFormat:@"%@/offer/all?page=%i&per_page=%i", HF_API_PATH_v2,pageNumber,perPage];
    return [[HFBaseAPIv2 sharedInstance] HFRequestGETWithURL:path
                                                  parameters:nil
                                                     success:^(id responseObject) {
                                                         successBlock([responseObject objectForKey:@"data"]);
                                                     } failure:^(NSError *error) {
                                                         failureBlock(error);
                                                     }];
 
}

+ (void)browseOpenCoupon:(NSNumber *)couponId
                 success:(void (^)())successBlock
                 failure:(void (^)(NSError * error))failureBlock
{
    if (!couponId) {
        NSLog(@"Empty Open Coupon Id");
        return;
    }
    //eg: http://localhost:8080/v2/collect/coupon/browse?user_id=5&coupon_id=8&timestamp=1415651743
    NSString *path = [NSString stringWithFormat:@"%@/offer/count/%@", HF_API_PATH_v2,couponId];
    NSLog(@"Open Coupon collection:%@", path);
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                            parameters:nil
                                               success:^(id responseObject) {
                                                   successBlock();
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];
}

+ (void)collectCoupon:(NSNumber *)couponId
           withUserId:(NSString *)userId
              success:(void (^)())successBlock
              failure:(void (^)(NSError * error))failureBlock
{
    if (!couponId) {
        NSLog(@"Empty Coupon Id");
        return;
    }
    if (!userId) {
        NSLog(@"Empty User Id");
        return;
    }
    //eg: http://localhost:8080/v2/collect/coupon/browse?user_id=5&coupon_id=8&timestamp=1415651743
    long long milliseconds = (long long)[[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld",milliseconds];
    NSString *path = [NSString stringWithFormat:@"%@/collect/coupon/browse?user_id=%@&coupon_id=%@&timestamp=%@", HF_API_PATH_v2,userId,couponId,timestamp];
    NSLog(@"Coupon collection:%@", path);
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                            parameters:nil
                                               success:^(id responseObject) {
                                                   successBlock();
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];
}

+ (void)applyCoupon:(NSNumber *)couponId
         withUserId:(NSString *)userId
            success:(void (^)())successBlock
            failure:(void (^)(NSError * error))failureBlock{
    if (!couponId) {
        NSLog(@"Empty Coupon Id");
        return;
    }
    //eg: http://54.183.40.21:8080/v2/collect/coupon/usage/applied?user_id=5&coupon_id=8&timestamp=1415651743
    long long milliseconds = (long long)[[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld",milliseconds];
    NSString *path = [NSString stringWithFormat:@"%@/collect/coupon/usage/applied?user_id=%@&coupon_id=%@&timestamp=%@", HF_API_PATH_v2,userId ? userId : @"",couponId,timestamp];
    NSLog(@"Coupon applied:%@", path);
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                            parameters:nil
                                               success:^(id responseObject) {
                                                   successBlock();
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];

}

+ (void)denyCoupon:(NSNumber *)couponId
        withUserId:(NSString *)userId
           success:(void (^)())successBlock
           failure:(void (^)(NSError * error))failureBlock{
    if (!couponId) {
        NSLog(@"Empty Coupon Id");
        return;
    }
    //eg: http://54.183.40.21:8080/v2/collect/coupon/usage/denied?user_id=5&coupon_id=8&timestamp=1415651743
    long long milliseconds = (long long)[[NSDate date] timeIntervalSince1970];
    NSString *timestamp=[NSString stringWithFormat:@"%lld",milliseconds];
    NSString *path = [NSString stringWithFormat:@"%@/collect/coupon/usage/denied?user_id=%@&coupon_id=%@&timestamp=%@", HF_API_PATH_v2,userId ? userId : @"",couponId,timestamp];
    NSLog(@"Coupon denied:%@", path);
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                            parameters:nil
                                               success:^(id responseObject) {
                                                   successBlock();
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];
}

@end
