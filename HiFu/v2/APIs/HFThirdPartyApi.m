//
//  HFThirdPartyApi.m
//  HiFu
//
//  Created by Peng Wan on 10/3/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFThirdPartyApi.h"
#import "HFBaseAPIv2.h"

@implementation HFThirdPartyApi

/*
 "uuid":"asdfad1123123",
 "loginMode":1,  // weibo是1，
 "weiboId":1803876591,
 "weiboName":"dabinbin",
 "weiboScreenName":"大彬彬",
 "weiboLocation":"北京 海淀区",
 "weiboProfileImgUrl":"http://tp4.sinaimg.cn/1803876591/50/0",
 "weiboVerified":false
 */

+ (NSString *)getUUID
{
    NSUUID  *UUID = [NSUUID UUID];
    return[UUID UUIDString];
}

+ (void)registerWeiboWithId:(NSString *)weiboId
                        weiboName:(NSString *)weiboName
                        weiboScreenName:(NSString *)weiboScreenName
                        weiboLocation:(NSString *)weiboLocation
                        weiboProfileImgUrl:(NSString *)weiboProfileImgUrl
                        weiboVerified:(NSNumber *)weiboVerified
                        success:(void (^)(id success))successBlock
                        failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/register/weibo", HF_API_PATH_v2];
    NSString *uuid = [self getUUID];
    NSDictionary *params = @{
                                @"uuid": uuid ?:@"",
                                @"loginMode":@1,
                                @"weiboId": weiboId ?:@"",
                                @"weiboName": weiboName ?:@"",
                                @"weiboScreenName": weiboScreenName ?:@"",
                                @"weiboLocation": weiboLocation ?:@"",
                                @"weiboProfileImgUrl": weiboProfileImgUrl ?:@"",
                                @"weiboVerified": weiboVerified
                            };
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                         parameters:params
                                            success:^(id responseObject) {
                                                successBlock(responseObject);
                                            } failure:^(NSError *error) {
                                                failureBlock(error);
                                            }];
}

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
                          failure:(void (^)(NSError * error))failureBlock{
    NSString *path = [NSString stringWithFormat:@"%@/register/qq", HF_API_PATH_v2];
    NSString *uuid = [self getUUID];
    NSDictionary *params = @{
                             @"uuid": uuid ?:@"",
                             @"loginMode":@3,
                             @"qqOpenId": openId ?:@"",
                             @"qqName": qqName ?:@"",
                             @"qqNickname": qqNickname ?:@"",
                             @"qqSex": qqSex ?:@"",
                             @"qqBirthDay": qqBirthDay ?:@1,
                             @"qqBirthMonth": qqBirthMonth ?:@1,
                             @"qqBirthYear": qqBirthYear ?:@1,
                             @"qqCountryCode": qqCountryCode ?:@"",
                             @"qqCityId": qqCityId ?:@"",
                             @"qqHomecityCode": qqHomecityCode ?:@"",
                             @"qqHomeprovinceCode": qqHomeprovinceCode ?:@"",
                             @"qqHomecountryCode": qqHomecountryCode ?:@"",
                             @"qqHometownCode": qqHometownCode ?:@"",
                             @"qqHeadImgUrl": qqHeadImgUrl ?:@""
                             };
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                            parameters:params
                                               success:^(id responseObject) {
                                                   successBlock(responseObject);
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];

    
}

+ (void)registerWechatWithOpenId:(NSString *)openId
                  wechatNickname:(NSString *)wechatNickname
                       wechatSex:(NSString *)wechatSex
                      wechatCity:(NSString *)wechatCity
                  wechatProvince:(NSString *)wechatProvince
                   wechatCountry:(NSString *)wechatCountry
                wechatHeadImgUrl:(NSString *)wechatHeadImgUrl
                         success:(void (^)(id success))successBlock
                         failure:(void (^)(NSError * error))failureBlock{
    NSString *path = [NSString stringWithFormat:@"%@/register/wechat", HF_API_PATH_v2];
    NSString *uuid = [self getUUID];
    NSDictionary *params = @{
                             @"uuid": uuid ?:@"",
                             @"loginMode":@2,
                             @"openId": openId ?:@"",
                             @"wechatNickname": wechatNickname ?:@"",
                             @"wechatSex": wechatSex ?:@"",
                             @"wechatCity": wechatCity ?:@"",
                             @"wechatProvince": wechatProvince ?:@"",
                             @"wechatCountry": wechatCountry ?:@"",
                             @"wechatHeadImgUrl": wechatHeadImgUrl ?:@"",
                             };
    [[HFBaseAPIv2 sharedInstance] HFRequestPOSTWithURL:path
                                            parameters:params
                                               success:^(id responseObject) {
                                                   successBlock(responseObject);
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];
}
@end
