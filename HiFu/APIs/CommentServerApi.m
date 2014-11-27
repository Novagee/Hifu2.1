//
//  CommentServerApi.m
//  HiFu
//
//  Created by Yin Xu on 8/2/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "CommentServerApi.h"
#import "HFBaseApi.h"

@implementation CommentServerApi

+ (void)getCommentsForCouponId:(NSString *)couponId
                    pageNumber:(int)pageNumber
               commentsPerPage:(int)perPage
                       success:(void (^)(id comments))successBlock
                       failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/comment/all/coupon/%@", HF_API_PATH, couponId];
    [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                         parameters:nil
                                            success:^(id responseObject) {
                                                successBlock(responseObject);
                                            } failure:^(NSError *error) {
                                                failureBlock(error);
                                            }];
}

+ (void)addCommentsForCouponId:(NSString *)couponId
                    withUserId:(NSString *)userId
                    andContent:(NSString *)content
                       success:(void (^)())successBlock
                       failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/comment", HF_API_PATH];
    NSDictionary *parameters= @{@"userId"  : userId,
                                @"couponId": couponId,
                                @"content" : content};
    
    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:path
                                          parameters:parameters
                                             success:^(id responseObject) {
                                                 successBlock();
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];
}


@end
