 //
//  ServerModel.m
//  HiFu
//
//  Created by Rich on 6/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "ServerModel.h"


#include <AFNetworking/AFNetworking.h>
#import "EasyData.h"
#import "StringOperations.h"
#import "UserServerApi.h"



//BLOCKS
typedef void (^dictCompletion) (NSDictionary *favorites, bool success);
typedef void (^idCompletion)   (id *responseObject, bool success);
typedef void (^basicComplete)  (bool success);

//SERVER_REQUEST_PATHS



@implementation ServerModel
@synthesize userInfo =_userInfo;

#pragma mark - check matching VCode

-(void)setUserInfo:(UserObject *)userInfo{
    _userInfo =userInfo;
}

-(NSArray *)mobileCode{
    return [NSArray arrayWithArray:_mobileCode];
}

-(void)clearMobileCode{
    _mobileCode = nil;
}

-(void)addVCode:(NSString*)newCode{
    if ([newCode isKindOfClass:NSNull.class]) {
        return;
    }
    if (!_mobileCode) {
        _mobileCode = [[NSMutableArray alloc]initWithCapacity:10];
        [NSTimer scheduledTimerWithTimeInterval:180.0 target:self selector:@selector(clearMobileCode) userInfo:nil repeats:NO];
    }
    if (self.mobileCode.count ==10) {
        [_mobileCode removeObjectAtIndex:0];
    }
    [_mobileCode addObject:newCode];
}

-(BOOL)validCode:(NSString*)code{
    
    for (NSString*vCode in self.mobileCode) {
        if  ([vCode isEqualToString:code]){
            return YES;
        }
    }
    return NO;
}

#pragma mark -

-(BOOL)isCCChina{
    
    if ([self.countryCode isEqualToString:@"86"]){
        return YES;
    }else{
        return NO;
    }
}


-(NSString *)userId{
    if   (!_userId) {
        _userId = [self.userInfo itemId];
    }
    return _userId;
}


-(UserObject *)userInfo{
    if (_userInfo) {
        return _userInfo;
    }
    if (![EasyData getDataWithKey:@"UserInfo"]) {
        return nil;
    }
    _userInfo = [[UserObject alloc] initWithDictionary:[EasyData getDataWithKey:@"UserInfo"]];
    return _userInfo;
}

#pragma mark - Bottom Network Layers -



-(void)createUser{
    [self createUserWithCompletion:nil];
}



-(void)createUserWithCompletion:(basicComplete)completion{
    if (!self.mobileCode) {
        return;
    }
    
    [self createUUIDUserWithCompletion:completion];
}



#pragma mark - signUp wuth UUID

-(void)createUUIDUserWithCompletion:(basicComplete)completion{

    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if (!self.mobileNumber) {
        _mobileNumber = @"";
    }
    
    if (![UserServerApi sharedInstance].userCountryCode) {
        _countryCode = @"";
    }
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    if (self.userId) {
        [parameters setObject:self.userId forKey:@"id"];
    
    }
    else{
        [parameters setObject:idfv forKey:@"uuid"];
    }
    
    if (![self.mobileNumber isEqualToString:@""])  {
//        NSDictionary *mobileData = @{@"countryCode": [UserServerApi sharedInstance].userCountryCode,//[NSNumber numberWithInt:[self.countryCode intValue]],
//                                     @"countryName": [StringOperations countryNameFromCode:[UserServerApi sharedInstance].userCountryCode],
//                                        @"phoneNum": self.mobileNumber};
        
        
        
        // I can't figure out why they pass the "country" code from the "UserServerApi" to the "ServerModel"
        //
        NSDictionary *mobileData = @{@"countryCode": self.countryCode,
                                     @"countryName": ([self.countryCode isEqualToString:@"86"]?
                                                      @"China" : @"US"),
                                        @"phoneNum": self.mobileNumber};
        
        [parameters addEntriesFromDictionary:mobileData];
    }
    
    
    NSLog(@"params: %@",parameters);
    
    
    
    [self.lowLayer doPOSTWithURL:SER_PATH_CREATE_USER
                      Parameters:parameters
                        plainRes:NO
                      Completion:^(id responseObject, bool success) {
                          
                          NSLog(@"res obj : %@",responseObject);
                          if (!success) {
                              if(completion!=NULL){
                                  completion(NO);
                              }
                              return;
                          }
                          
                          _userInfo = [[UserObject  alloc] initWithDictionary:responseObject[@"user"]];
                          _userInfo.loginChannel = @"LOGIN_CHANNEL_MOBILE";
                          [[UserServerApi sharedInstance] setCurrentUser:_userInfo];
                          if(completion!=NULL){
                              completion(YES);
                          }
                      }];
}

#pragma mark - add/rem favs
/*
-(void)remFavorite:(int)couponId
       shouldQueue:(BOOL)queue
        Completion:(basicComplete)completion{

    if (!self.userId) {
        return;
    }
    
    NSString *postPath = SER_PATH_FAVS_ADD_REM(self.userId,couponId);
    
    [self.lowLayer doDELETEWithURL:postPath
                        Parameters:nil
                        Completion:^(id responseObject, bool success) {
                            
                            if (!success) {
                                if (queue) {
                                    [[FavModel sharedManager] queueAddReqId:
                                     [NSString stringWithFormat:@"%i",couponId]];
                                    
                                }
                                return;
                            }
                            
                            if (completion!=NULL) {
                                completion(success);
                            }
                            
                            NSLog(@"DELETE FAV %i",couponId);
                        }];
}



-(void)addFavorite:(int)couponId
       shouldQueue:(BOOL)queue
        Completion:(basicComplete)completion{
    
    if (!self.userId) {
        return;
    }
    
    NSString *postPath = SER_PATH_FAVS_ADD_REM(self.userId,couponId);
    
    [self.lowLayer doPOSTWithURL:postPath
                      Parameters:nil
                        plainRes:YES
                      Completion:^(id responseObject, bool success) {
                          if (!success) {
                              if (queue) {
                                  [[FavModel sharedManager] queueAddReqId:
                                   [NSString stringWithFormat:@"%i",couponId]];
                                  
                              }
                              return;
                          }
                          
                          if (completion!=NULL) {   
                              completion(success);
                          }
                      }];
}
*/


#pragma mark - Top Network Layers -

//*
//*  USED BY BUTTON TO RESEND FROM ENTERCODE VC
//*

-(void)reValidate{
      [self vailidateMobile:self.mobileNumber
                    Country:self.countryCode
                   Location:self.cordLocation];
}

/*
-(void)loadUserFavorites:(NSString*)userId
              Completion:(dictCompletion)completion{
    
    NSString *path = SER_PATH_FAVS_LOAD(userId);
    NSURL    *url  = [NSURL URLWithString:path];
    
    self.userId = userId;
    

    [self.lowLayer doGETWithURL:url
                     Completion:^(id responseObject, bool success) {
                         
        //NSLog(@"FAVS : %@",responseObject[@"returnedCoupons"]);
                         

        if (success) {
            completion(responseObject, YES);
        }else{
            completion(nil, NO);
        }
        
    }];
}
*/

/*
-(void)couponsForLocationLatitude:(float)latitude
                       Longitutde:(float)longitude
                       Completion:(dictCompletion)completion{
    
    NSString *path = SER_PATH_COUP_LOC(latitude, longitude);
    NSLog(@"PATH %@",path);
    NSURL    *url  = [NSURL URLWithString:path];
    
    self.cordLocation = CGPointMake(latitude, longitude);
    
    [self.lowLayer doGETWithURL:url Completion:^(id responseObject, bool success) {
        if (success) {
            completion(responseObject, YES);
        }else{
            completion(nil, NO);
        }
    }];
}
*/


-(void)vailidateMobile:(NSString*)mobile
               Country:(NSString*)country
              Location:(CGPoint)llcord{
    
    country = [UserServerApi sharedInstance].userCountryCode;
    
    if (!mobile) {
        NSLog(@"mobile number saved as nil.");
        return;
    }
    
    NSLog(@"%@ -> %@", mobile, country);
    
    NSURL *url = [NSURL URLWithString:SER_PATH_VERIFY];
    
    url = [url URLByAppendingPathComponent:country];
    
    url = [url URLByAppendingPathComponent:mobile];
    
    NSLog(@"Request : %@", url);
    
//    self.mobileCode = nil;
    
    [self.lowLayer doGETWithURL:url Completion:^(id responseObject, bool success) {
        if (success) {
            NSDictionary* retData = responseObject;
            [self addVCode: retData[@"message"]];
            //SAVED FOR reValidate METHOD
            self.mobileNumber = mobile;
            self.countryCode  = country;
        }
    }];
}




#pragma mark - Inititialize Stuff -



-(void)singletonInit{
    _lowLayer = [[HFBaseApi alloc]init];
}



+(id) allocWithZone:(NSZone *)zone{
    return [ServerModel sharedManager];
}



+(ServerModel *) sharedManager{
    static ServerModel  *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance =  [[super allocWithZone:NULL] init];
        [sharedInstance singletonInit];
    });
    return sharedInstance;
}



@end
