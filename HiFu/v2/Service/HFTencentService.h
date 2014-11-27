//
//  HFThirdPartyService.h
//  HiFu
//
//  Created by Peng Wan on 9/24/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AFNetworking/AFNetworking.h>
#import "HFMacro.h"


@interface HFTencentService : NSObject<TencentSessionDelegate>

+ (HFTencentService *)getInstance;


- (void) initTencent;


@end
