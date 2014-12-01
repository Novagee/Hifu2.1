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
{
    BOOL alertIsShowing;
}


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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //UA
        UAConfig *config = [UAConfig defaultConfig];
        
        // You can also programmatically override the plist values:
        // config.developmentAppKey = @"YourKey";
        // etc.
        
        // Call takeOff (which creates the UAirship singleton)
        [UAirship takeOff:config];
        
        // Request a custom set of notification types
        [UAPush shared].userNotificationTypes = (UIUserNotificationTypeAlert |
                                                 UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound);
        
        [UAPush shared].userPushNotificationsEnabled = YES;
        
        alertIsShowing = NO;
    });

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
    UA_LDEBUG(@"Application did become active.");
    
    // Set the icon badge to zero on resume (optional)
    [[UAPush shared] resetBadge];
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    UA_LTRACE(@"Application registered for remote notifications with device token: %@", deviceToken);
    [[UAPush shared] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
    
    //apns token
//    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
//    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    UA_LTRACE(@"Application did register with user notification types %ld", (unsigned long)notificationSettings.types);
    [[UAPush shared] appRegisteredUserNotificationSettings];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    UA_LERR(@"Application failed to register for remote notifications with error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UA_LINFO(@"Application received remote notification: %@", userInfo);
    [[UAPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    UA_LINFO(@"Application received remote notification: %@", userInfo);
    [[UAPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())handler {
    UA_LINFO(@"Received remote notification button interaction: %@ notification: %@", identifier, userInfo);
    [[UAPush shared] appReceivedActionWithIdentifier:identifier notification:userInfo applicationState:application.applicationState completionHandler:handler];
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
