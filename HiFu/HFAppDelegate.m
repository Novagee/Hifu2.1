//
//  HFAppDelegate.m
//  HiFu
//
//  Created by Yin Xu on 7/29/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <Appsee/Appsee.h>
#import "HFMacro.h"
#import "HFWeiboService.h"
#import "HFWeixinService.h"
#import "HFAppDelegate.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "HFShareHelpers.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appsee start:AppSeeAPIKey];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:sinaWeiboAppKey];
    [WXApi registerApp:wechatAppKey withDescription:@"HiFu"];
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    //TABBAR
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:HeitiSC_Medium(11)}
                                             forState:UIControlStateNormal];
    
    //NAVBAR
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:HeitiSC_Medium(14)}
                                                                                            forState:UIControlStateNormal];
    
    
    //ADJUST ICON TINT FOR TABBAR
    [[UITabBar appearance] setTintColor:HFTabBarDefaultColor];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f]];
    
    //Set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Register wechat sdk
//    [WXApi registerApp:WECHAT_APP_KEY withDescription:@"HiFu"];
    
    //Register weibo sdk
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:WEIBO_APP_KEY];
    
    [self appFirstLaunch];
    
    return YES;
}

#pragma mark - App first Launch Stuff

- (void)appFirstLaunch {
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"appLaunched"]) {
        [[NSUserDefaults standardUserDefaults]setValue:@NO forKey:@"appFirstLaunch"];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setValue:@YES forKey:@"appLaunched"];
        [[NSUserDefaults standardUserDefaults]setValue:@YES forKey:@"appFirstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark login with SNS
// wechat delegate methods start
-(void)sendWechatAuthRequest
{
    [[HFWeixinService getInstance] sendWechatAuthRequest];
}

-(void) onReq:(BaseReq *)req
{
    NSLog(@"Wechat request: %@", req);
}

-(void) onResp:(BaseResp *)resp
{
    [[HFWeixinService getInstance] doReceiveWeixinResponse:resp];
}
// wechat delegate methods end


// weibo delegate methods start
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        NSLog(@"ReceiveWeiboRequest: %@", request);
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        NSLog(@"Weibo 发送结果: %@ ", message);
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse* wbresp = (WBAuthorizeResponse *)response;
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[wbresp userID], [wbresp accessToken], response.userInfo, response.requestUserInfo];
        NSLog(@"Weibo 认证成功: %@ ", message);
        [[HFWeiboService getInstance] doReceiveLoginResponse:wbresp];
    }
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//        WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//        WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//        WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//        WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//        WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//        WeiboSDKResponseStatusCodeUnknown               = -100,

        
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
}
// weibo delegate methods end

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[HFShareHelpers class]];
#endif
    return [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

/*
 * 推荐实现上面的方法，两个方法二选一实现即可
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[HFShareHelpers class]];
#endif
    return [ WeiboSDK handleOpenURL:url delegate:self ] || [TencentOAuth HandleOpenURL:url] ||[WXApi handleOpenURL:url delegate:self];
}

@end
