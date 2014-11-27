//
//  CommentServerApi.h
//  HiFu
//
//  Created by Yin Xu on 8/2/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentServerApi : NSObject

+ (void)getCommentsForCouponId:(NSString *)couponId
                    pageNumber:(int)pageNumber
               commentsPerPage:(int)perPage
                      success:(void (^)(id comments))successBlock
                      failure:(void (^)(NSError * error))failureBlock;

+ (void)getCommentsForCouponId:(NSString *)couponId
                    pageNumber:(int)pageNumber
               commentsPerPage:(int)perPage
                       success:(void (^)(id comments))successBlock
                       failure:(void (^)(NSError * error))failureBlock;

+ (void)addCommentsForCouponId:(NSString *)couponId
                    withUserId:(NSString *)userId
                    andContent:(NSString *)content
                       success:(void (^)())successBlock
                       failure:(void (^)(NSError * error))failureBlock;

@end
