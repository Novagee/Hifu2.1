//
//  UserServerApi.h
//  HiFu
//
//  Created by Yin Xu on 7/13/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserObject;

@interface UserServerApi : NSObject
{
    UserObject *_currentUser;
}

@property (nonatomic, strong) UserObject *currentUser;
@property (nonatomic, readonly) NSString *currentUserId;
@property (nonatomic, strong) NSString *userCountryCode;
@property (nonatomic, strong) NSMutableArray *mobileCode;
@property (nonatomic, strong) NSString *mobileNumber;

+ (instancetype)sharedInstance;

//users
- (void)createUser;
- (void)logoutUser;
- (void)createUserSuccess:(void (^)())successBlock
                  failure:(void (^)(NSError * error))failureBlock;
- (void)createUUIDUserSuccess:(void (^)())successBlock
                      failure:(void (^)(NSError * error))failureBlock;
- (void)updateCurrentUserWithParams:(NSMutableDictionary *)params
                            success:(void (^)(id userInfo))successBlock
                            failure:(void (^)(NSError * error))failureBlock;
@end
