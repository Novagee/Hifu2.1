//
//  HFCouponApi.h
//  HiFu
//
//  Created by Peng Wan on 11/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFBaseAPIv2.h"

@interface HFCouponApi : HFBaseAPIv2


+ (id)getCouponsByPageNumber:(int)pageNumber
                            couponPerPage:(int)perPage
                            success:(void (^)(id coupons))successBlock
                            failure:(void (^)(NSError * error))failureBlock;

                                
+ (void)browseOpenCoupon:(NSNumber *)couponId
                success:(void (^)())successBlock
                failure:(void (^)(NSError * error))failureBlock;

+ (void)collectCoupon:(NSNumber *)couponId
           withUserId:(NSString *)userId
              success:(void (^)())successBlock
              failure:(void (^)(NSError * error))failureBlock;

+ (void)applyCoupon:(NSNumber *)couponId
           withUserId:(NSString *)userId
              success:(void (^)())successBlock
              failure:(void (^)(NSError * error))failureBlock;

+ (void)denyCoupon:(NSNumber *)couponId
         withUserId:(NSString *)userId
            success:(void (^)())successBlock
            failure:(void (^)(NSError * error))failureBlock;

@end
