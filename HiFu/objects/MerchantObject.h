//
//  MerchantObject.h
//  HiFu
//
//  Created by Yin Xu on 7/17/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h""

@interface MerchantObject : BaseObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameCn;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantNameCN;
@property (nonatomic, strong) NSString *aliasCN;
@property (nonatomic, strong) NSString *logoPictureURL;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *aliasCn;
@property (nonatomic, strong) NSString *logoPictureUrl;
@property (nonatomic, strong) NSString *coverPictureUrl;
@property (nonatomic, strong) NSString *titleLogoPictureUrl;
@property (nonatomic, assign) BOOL isOurClient;

@end
