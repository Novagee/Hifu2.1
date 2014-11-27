//
//  HFWeiboService.h
//  HiFu
//
//  Created by Peng Wan on 9/24/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "HFMacro.h"
#import "WeiboSDK.h"

@interface HFWeiboService : NSObject<WBHttpRequestDelegate>

+ (HFWeiboService *)getInstance;

- (void) initWeiboLoginAuthorizeRequest;
- (void) doReceiveLoginResponse:(WBBaseResponse *)response;

- (WBMessageObject *)buildWeiboMessage:(NSString *)messageType;
- (void)shareMessage:(WBMessageObject *)message;
@end
