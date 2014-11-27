//
//  HFWeixinService.h
//  HiFu
//
//  Created by Peng Wan on 9/24/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface HFWeixinService : NSObject

+ (HFWeixinService *)getInstance;

- (void) sendTextContent;
- (void) sendWechatAuthRequest;
- (void) doReceiveWeixinResponse:(BaseResp *)resp;



@end
