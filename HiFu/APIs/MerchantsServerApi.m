//
//  MerchantsServerApis.m
//  HiFu
//
//  Created by Yin Xu on 7/17/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "MerchantsServerApi.h"
#import "HFBaseApi.h"

@implementation MerchantsServerApi

+ (void)getMerchantsForUser:(NSString *)userId
              withTimeStamp:(NSNumber *)timeStamp
                    success:(void (^)(id allUpdatedMerchants, id favoriteMerchantId))successBlock
                    failure:(void (^)(NSError * error))failureBlock
{
    //eg: http://54.183.40.21:8080/restful/merchant/favorite/{userId}?milliseconds={timestamp}
    NSString *path = [NSString stringWithFormat:@"%@/merchant/favorite/%@/", HF_API_PATH, userId];
    
    NSDictionary *params = @{@"milliseconds": timeStamp ?:@""};
    [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                         parameters:params
                                            success:^(id responseObject) {
                                                NSDictionary *allUpdatedMerchants = [responseObject objectForKey:@"allUpdatedMerchants"];
                                                
                                                if (allUpdatedMerchants && ![allUpdatedMerchants isKindOfClass:[NSNull class]] && [allUpdatedMerchants count] > 0) {
                                                    [[NSUserDefaults standardUserDefaults] setObject:[allUpdatedMerchants objectForKey:@"timestamp"] forKey:@"merchantUpdatedTimeStamp"];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    successBlock([allUpdatedMerchants objectForKey:@"allMerchants"],
                                                                 [responseObject objectForKey:@"favoriteMerchantsId"]);
                                                }
                                                else
                                                {
                                                    successBlock(nil, [responseObject objectForKey:@"favoriteMerchantsId"]);
                                                }
                                            }
                                            failure:^(NSError *error) {
                                                NSLog(@"%@", error);
                                            }];

}

+ (void)favoriteMerchantsId:(NSString *)merchantId
                 withUserId:(NSString *)userId
                    success:(void (^)())successBlock
                    failure:(void (^)(NSError * error))failureBlock
{
    //eg: http://54.183.40.21:8080/restful/merchant/favorite/{userId}/{merchantId}
    NSString *path = [NSString stringWithFormat:@"%@/merchant/favorite/%@/%@", HF_API_PATH, userId, merchantId];
    
    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:path
                                          parameters:nil
                                             success:^(id responseObject) {
                                                 successBlock();
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];

}

+ (void)unfavoriteMerchantsId:(NSString *)merchantId
                   withUserId:(NSString *)userId
                      success:(void (^)())successBlock
                      failure:(void (^)(NSError * error))failureBlock
{
    //eg: http://54.183.40.21:8080/restful/merchant/favorite/{userId}/{merchantId}
    NSString *path = [NSString stringWithFormat:@"%@/merchant/favorite/%@/%@", HF_API_PATH, userId, merchantId];
    
    [[HFBaseApi sharedInstance] HFRequestDELETEWithURL:path
                                            parameters:nil success:^(id responseObject) {
                                                successBlock();
                                            } failure:^(NSError *error) {
                                                failureBlock(error);
                                            }];

}

+ (id)getStoreForMerchant:(NSString *)merchantId
             withLocation:(CLLocation *)location
               inDistance:(float)distance
                  success:(void (^)(id stores))successBlock
                  failure:(void (^)(NSError * error))failureBlock
{
    //eg: http://54.183.40.21:8080/restful/store/near/coupon/{couponId}?lat=%f&lon=%f&dis=%f
    NSString *path = [NSString stringWithFormat:@"%@/store/near/coupon/%@/", HF_API_PATH, merchantId];
    
    NSDictionary *params = @{@"lat": @(location.coordinate.latitude),
                             @"lon": @(location.coordinate.longitude),
                             @"dis": @(distance)};
    
    return [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                                parameters:params
                                                   success:^(id responseObject) {
                                                       successBlock(responseObject);
                                                   } failure:^(NSError *error) {
                                                       failureBlock(error);
                                                   }];

}

@end
