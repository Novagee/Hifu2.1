//
//  HFUserApi.h
//  HiFu
//
//  Created by Peng Wan on 11/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFBaseAPIv2.h"

@interface HFUserApi : HFBaseAPIv2

+ (void)favoriteStoreId:(NSNumber *)storeId
                 withUserId:(NSString *)userId
                    success:(void (^)())successBlock
                    failure:(void (^)(NSError * error))failureBlock;

+ (void)unfavoriteStoreId:(NSNumber *)storeId
                   withUserId:(NSString *)userId
                      success:(void (^)())successBlock
                      failure:(void (^)(NSError * error))failureBlock;

+ (void)registerDefaultUserSuccess:(void (^)())successBlock
                  failure:(void (^)(NSError * error))failureBlock;

@end
