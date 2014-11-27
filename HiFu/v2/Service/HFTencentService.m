//
//  HFThirdPartyService.m
//  HiFu
//
//  Created by Peng Wan on 9/24/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFTencentService.h"
#import "HFThirdPartyApi.h"
#import "UserServerApi.h"
#import "UserObject.h"

@implementation HFTencentService

+ (HFTencentService *)getInstance {
    static HFTencentService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HFTencentService alloc] init];
    });
    
    return _sharedInstance;
}

- (void) initTencent
{
    UserObject *user = [UserServerApi sharedInstance].currentUser;
    if(!user){
        user = [[UserObject alloc]init];
        [[UserServerApi sharedInstance] setCurrentUser:user];
    }
    [UserServerApi sharedInstance].currentUser.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APP_KEY
                                            andDelegate:self];
    [UserServerApi sharedInstance].currentUser.tencentOAuth.redirectURI = QQ_APP_RedirectURI;
    [UserServerApi sharedInstance].currentUser.tencentPermissions = [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];
}

- (void)tencentDidLogin
{
    NSLog(@"QQ login token: %@", [UserServerApi sharedInstance].currentUser.tencentOAuth.accessToken);
    if ([UserServerApi sharedInstance].currentUser.tencentOAuth.accessToken && 0 != [[UserServerApi sharedInstance].currentUser.tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"QQ login token: %@", [UserServerApi sharedInstance].currentUser.tencentOAuth.accessToken);
        NSString *url = @"https://graph.qq.com/user/get_user_info";
        AFHTTPSessionManager *urlSession = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
        [urlSession setRequestSerializer: [AFJSONRequestSerializer serializer]];
        [urlSession setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [urlSession.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        if ([NSURLSession class]){
            if ([UserServerApi sharedInstance].currentUser.tencentOAuth.openId && [UserServerApi sharedInstance].currentUser.tencentOAuth.accessToken) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HFLOGINSHOWMASK object:nil userInfo:nil];
                NSDictionary* params = @{
                                         @"oauth_consumer_key":QQ_APP_KEY,
                                         @"access_token": [UserServerApi sharedInstance].currentUser.tencentOAuth.accessToken,
                                         @"openid": [UserServerApi sharedInstance].currentUser.tencentOAuth.openId,
                                         @"format":@"json"
                                         };
                [urlSession
                 GET:url
                 parameters:params
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     NSLog(@"%@",responseObject);
                     [HFThirdPartyApi
                      registerTencentWithOpenId:[UserServerApi sharedInstance].currentUser.tencentOAuth.openId
                                         qqName:responseObject[@"nickname"]
                                     qqNickname:responseObject[@"nickname"]
                                          qqSex:responseObject[@"gender"]
                                     qqBirthDay:responseObject[@"day"]
                                   qqBirthMonth:responseObject[@"month"]
                                    qqBirthYear:responseObject[@"year"]
                                  qqCountryCode:responseObject[@"country"]
                                       qqCityId:responseObject[@"city"]
                                 qqHomecityCode:responseObject[@"city"]
                             qqHomeprovinceCode:responseObject[@"province"]
                              qqHomecountryCode:responseObject[@"country"]
                                 qqHometownCode:responseObject[@"province"]
                                   qqHeadImgUrl:responseObject[@"figureurl_qq_2"]
                                        success:^(id success) {
                                            NSLog(@"Registered qq successfully.");
                                            //remove local user data
                                            if (success&&success[@"data"]&&success[@"data"][@"id"]) {
                                                //should save oath info
                                                UserObject *user = [[UserObject alloc]initWithDictionary:success[@"data"]];
                                                user.loginChannel = @"LOGIN_CHANNEL_QQ";
                                                user.displayName = success[@"data"][@"qqNickname"];
                                                user.imageUrl = success[@"data"][@"qqHeadImgUrl"];
                                                [[UserServerApi sharedInstance] setCurrentUser:user];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:HFLOGINHIDEMASKANDENTER object:nil userInfo:nil];
                                                NSLog(@"Saved To Sesion");
                                            }
                                        } failure:^(NSError *error) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:HFLOGINHIDEMASK object:nil userInfo:nil];
                                            NSLog(@"Registered qq unsuccessfully.");
                                        }];
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"Error: %@",error);
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取用户信息结果"
                                                                     message:[error localizedDescription]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }];
            }
        }
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"用户取消登录");
    }
    else
    {
        NSLog(@"登录失败");
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}

@end
