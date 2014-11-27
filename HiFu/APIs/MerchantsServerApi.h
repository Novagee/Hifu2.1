//
//  MerchantsServerApi.h
//  HiFu
//
//  Created by Yin Xu on 7/17/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@interface MerchantsServerApi : NSObject

+ (void)getMerchantsForUser:(NSString *)userId
              withTimeStamp:(NSNumber *)timeStamp
                    success:(void (^)(id allUpdatedMerchants, id favoriteMerchantId))successBlock
                    failure:(void (^)(NSError * error))failureBlock;

+ (void)favoriteMerchantsId:(NSString *)merchantId
                 withUserId:(NSString *)userId
                    success:(void (^)())successBlock
                    failure:(void (^)(NSError * error))failureBlock;

+ (void)unfavoriteMerchantsId:(NSString *)merchantId
                   withUserId:(NSString *)userId
                      success:(void (^)())successBlock
                      failure:(void (^)(NSError * error))failureBlock;

+ (id)getStoreForMerchant:(NSString *)merchantId
             withLocation:(CLLocation *)location
               inDistance:(float)distance
                  success:(void (^)(id stores))successBlock
                  failure:(void (^)(NSError * error))failureBlock;

@end
