//
//  UserServerApi.m
//  HiFu
//
//  Created by Yin Xu on 7/13/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "UserServerApi.h"
#import "HFGeneralHelpers.h"
#import "HFBaseApi.h"
#import "HFUserApi.h"
#import "UserObject.h"
#import <Appsee/Appsee.h>

//typedef void (^successBlock)();
//typedef void (^failureBlock)();

@implementation UserServerApi

@synthesize currentUser = _currentUser;

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static UserServerApi *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[self alloc] init];
    });
    return obj;
}


#pragma mark - User Object setter/getter

- (void)setCurrentUser:(UserObject *)currentUser
{
    if (!currentUser) return;
    
    _currentUser = currentUser;
    [Appsee setUserID:_currentUser.itemId];//set app see user id
    [HFGeneralHelpers saveData:currentUser toFileAtPath:[HFGeneralHelpers dataFilePath:HFCurrentUserPath]];
}

- (UserObject *)currentUser
{
    if(!_currentUser)
    {
        _currentUser = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFCurrentUserPath]];
    }
    return _currentUser;
}

- (NSString *)currentUserId
{
    return _currentUser.itemId;
}

#pragma mark - Apis
-(void)createUser{
    [self createUserSuccess:nil failure:nil];
}

-(void)createUserSuccess:(void (^)())successBlock
                 failure:(void (^)(NSError * error))failureBlock
{
    if (!self.mobileCode) {
        return;
    }
    
    [self createUUIDUserSuccess:successBlock failure:failureBlock];
}

-(void)createUUIDUserSuccess:(void (^)())successBlock
                     failure:(void (^)(NSError *))failureBlock
{
    if (!self.mobileNumber) {
        _mobileNumber = @"";
    }
    
    if (!self.userCountryCode) {
        _userCountryCode = @"";
    }
    
    NSMutableDictionary * parameters = [NSMutableDictionary new];
    [parameters setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"uuid"];
    if (![self.mobileNumber isEqualToString:@""])  {
        [parameters setObject:@"countryCode" forKey:self.userCountryCode];
        [parameters setObject:@"countryName" forKey:[HFGeneralHelpers countryNameFromCode:self.userCountryCode]];
        [parameters setObject:@"phoneNum" forKey:self.mobileNumber];
    }
    
    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:SER_PATH_CREATE_USER
                                          parameters:parameters
                                             success:^(id responseObject) {
                                                 [self setCurrentUser:[[UserObject  alloc] initWithDictionary:responseObject[@"user"]]];
                                                 successBlock();
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];
}

- (void)updateCurrentUserWithParams:(NSMutableDictionary *)params
                            success:(void (^)(id userInfo))successBlock
                            failure:(void (^)(NSError * error))failureBlock
{
    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:SER_PATH_CREATE_USER
                                          parameters:params
                                             success:^(id responseObject) {
                                                 [self setCurrentUser:[[UserObject  alloc] initWithDictionary:responseObject[@"user"]]];
                                                 successBlock(responseObject);
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];
    
}

- (void)logoutUser{
    _currentUser = nil;
    [HFGeneralHelpers saveData:_currentUser toFileAtPath:[HFGeneralHelpers dataFilePath:HFCurrentUserPath]];
    [HFGeneralHelpers deleteDataFileAtPath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
    NSLog(@"User logged out.");
}

@end
