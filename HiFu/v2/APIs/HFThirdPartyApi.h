//
//  HFThirdPartyApi.h
//  HiFu
//
//  Created by Peng Wan on 10/3/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFThirdPartyApi : NSObject

+ (void)registerWeiboWithId:(NSString *)weiboId
                  weiboName:(NSString *)weiboName
            weiboScreenName:(NSString *)weiboScreenName
              weiboLocation:(NSString *)weiboLocation
         weiboProfileImgUrl:(NSString *)weiboProfileImgUrl
              weiboVerified:(NSNumber *)weiboVerified
                    success:(void (^)(id success))successBlock
                    failure:(void (^)(NSError * error))failureBlock;

+ (void)registerTencentWithOpenId:(NSString *)openId
                           qqName:(NSString *)qqName
                       qqNickname:(NSString *)qqNickname
                            qqSex:(NSString *)qqSex
                       qqBirthDay:(NSNumber *)qqBirthDay
                     qqBirthMonth:(NSNumber *)qqBirthMonth
                      qqBirthYear:(NSNumber *)qqBirthYear
                    qqCountryCode:(NSString *)qqCountryCode
                         qqCityId:(NSString *)qqCityId
                   qqHomecityCode:(NSString *)qqHomecityCode
               qqHomeprovinceCode:(NSString *)qqHomeprovinceCode
                qqHomecountryCode:(NSString *)qqHomecountryCode
                   qqHometownCode:(NSString *)qqHometownCode
                     qqHeadImgUrl:(NSString *)qqHeadImgUrl
                          success:(void (^)(id success))successBlock
                          failure:(void (^)(NSError * error))failureBlock;

+ (void)registerWechatWithOpenId:(NSString *)openId
                  wechatNickname:(NSString *)wechatNickname
                       wechatSex:(NSString *)wechatSex
                      wechatCity:(NSString *)wechatCity
                  wechatProvince:(NSString *)wechatProvince
                   wechatCountry:(NSString *)wechatCountry
                wechatHeadImgUrl:(NSString *)wechatHeadImgUrl
                         success:(void (^)(id success))successBlock
                         failure:(void (^)(NSError * error))failureBlock;

@end
