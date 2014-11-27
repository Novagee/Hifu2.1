//
//  HFUserApi.m
//  HiFu
//
//  Created by Peng Wan on 11/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFUserApi.h"
#import "HFBaseApi.h"

@implementation HFUserApi

+ (void)favoriteStoreId:(NSNumber *)storeId
             withUserId:(NSString *)userId
                success:(void (^)())successBlock
                failure:(void (^)(NSError * error))failureBlock;
{
    if (!storeId) {
        NSLog(@"Empty Store Id");
        return;
    }
    if (!userId) {
        NSLog(@"Empty User Id");
        return;
    }
    //eg: http://54.183.40.21:8080/restful/merchant/favorite/{userId}/{merchantId}
    NSString *path = [NSString stringWithFormat:@"%@/store/save/%@/%@", HF_API_PATH_v2, userId, storeId];
    
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                          parameters:nil
                                             success:^(id responseObject) {
                                                 successBlock();
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];

}

+ (void)unfavoriteStoreId:(NSNumber *)storeId
               withUserId:(NSNumber *)userId
                  success:(void (^)())successBlock
                  failure:(void (^)(NSError * error))failureBlock{
    if (!storeId) {
        NSLog(@"Empty Store Id");
        return;
    }
    if (!userId) {
        NSLog(@"Empty User Id");
        return;
    }
    //eg: http://54.183.40.21:8080/restful/merchant/favorite/{userId}/{merchantId}
    NSString *path = [NSString stringWithFormat:@"%@/store/save/%@/%@", HF_API_PATH_v2, userId, storeId];
    
    [[HFBaseAPIv2 sharedInstance] HFRequestDELETEWithURL:path
                                            parameters:nil
                                            success:^(id responseObject) {
                                                successBlock();
                                            } failure:^(NSError *error) {
                                                failureBlock(error);
                                            }];
}

+ (void)registerDefaultUserSuccess:(void (^)())successBlock
                    failure:(void (^)(NSError * error))failureBlock{
    //http://54.183.40.21:8080/v2/register/default
    NSString *path = [NSString stringWithFormat:@"%@/register/default", HF_API_PATH_v2];
    NSMutableDictionary * parameters = [NSMutableDictionary new];
    [parameters setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"uuid"];
    [parameters setObject:@0 forKey:@"loginMode"];
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                              parameters:parameters
                                              success:^(id responseObject) {
                                                  successBlock(responseObject);
                                              } failure:^(NSError *error) {
                                                  failureBlock(error);
                                              }];
}

@end
