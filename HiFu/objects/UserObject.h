//
//  UserObject.h
//  HiFu
//
//  Created by Rich on 6/30/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import <TencentOpenAPI/TencentOAuth.h>

//typedef enum
//{
//    LOGIN_CHANNEL_MOBILE = 0,
//    LOGIN_CHANNEL_WECHAT,
//    LOGIN_CHANNEL_WEIBO,
//    LOGIN_CHANNEL_QQ
//} LOGIN_CHANNEL;

@interface UserObject : BaseObject

@property (strong,nonatomic) NSString  *uuid;//: "xxx"
@property (assign,nonatomic) NSNumber  *countryCode;//: "xxx"
@property (strong,nonatomic) NSString  *countryName;//: "xxx"
@property (strong,nonatomic) NSString  *phoneNum;//: "xxx"
@property (strong,nonatomic) NSString  *registerTime;//: 1404171936000
@property (strong,nonatomic) NSNumber  *avatarNum;//: null
@property (strong,nonatomic) NSString  *gender;//: null
@property (strong,nonatomic) NSString  *alias;//: null

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString         *loginChannel;
@property (nonatomic, strong) TencentOAuth          *tencentOAuth;
@property (nonatomic, strong) NSArray               *tencentPermissions;
@property (nonatomic, strong) WBAuthorizeResponse   *weiboOAuth;


@property (nonatomic, strong) NSNumber*    loginMode;
@property (nonatomic, strong) NSString*     phoneCountryCode;
@property (nonatomic, strong) NSString*     phoneNumber;
@property (nonatomic, strong) NSString*     qqBirthDay;
@property (nonatomic, strong) NSString*     qqBirthMonth;
@property (nonatomic, strong) NSString*     qqBirthYear;
@property (nonatomic, strong) NSString*     qqCityId;
@property (nonatomic, strong) NSString*     qqCountryCode;
@property (nonatomic, strong) NSString*     qqHeadImgUrl;
@property (nonatomic, strong) NSString*     qqHomecityCode;
@property (nonatomic, strong) NSString*     qqHomecountryCode;
@property (nonatomic, strong) NSString*     qqHomeprovinceCode;
@property (nonatomic, strong) NSString*     qqHometownCode;
@property (nonatomic, strong) NSString*     qqName;
@property (nonatomic, strong) NSString*     qqNickname;
@property (nonatomic, strong) NSString*     qqOpenId;
@property (nonatomic, strong) NSString*     qqSex;
@property (nonatomic, strong) NSNumber*     registrationTime;
@property (nonatomic, strong) NSString*     wechatCity;
@property (nonatomic, strong) NSString*     wechatCountry;
@property (nonatomic, strong) NSString*     wechatHeadImgUrl;
@property (nonatomic, strong) NSString*    wechatNickname;
@property (nonatomic, strong) NSString*     wechatOpenId;
@property (nonatomic, strong) NSString*     wechatProvince;
@property (nonatomic, strong) NSString*     wechatSex;
@property (nonatomic, strong) NSNumber*     weiboId;
@property (nonatomic, strong) NSString*     weiboLocation;
@property (nonatomic, strong) NSString*     weiboName;
@property (nonatomic, strong) NSString*     weiboProfileImgUrl;
@property (nonatomic, strong) NSString*     weiboScreenName;
@property (nonatomic, strong) NSString*     weiboVerified;


@end
