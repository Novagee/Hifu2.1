//
//  HFAppDelegate.h
//  HiFu
//
//  Created by Yin Xu on 7/29/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

@interface HFAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
