//
//  ServerModel.h
//  HiFu
//
//  Created by Rich on 6/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFBaseApi.h"
#import "UserObject.h"

@interface ServerModel : NSObject

//DIRECT CALLS TO AFNETWORKING ON lowNetModel - lowLayer
@property (strong,nonatomic) HFBaseApi *lowLayer;

//USER OBJECT
@property (strong,nonatomic) UserObject *userInfo;

@property (strong, nonatomic) NSMutableArray *mobileCode;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *countryCode;
@property (nonatomic) CGPoint cordLocation;
@property (nonatomic) NSString *userId;


//Country Code
-(BOOL)isCCChina;



//users
-(void)createUser;

-(void)createUserWithCompletion:(void (^)(bool success))completion;

-(void)createUUIDUserWithCompletion:(void (^)(bool success))completion;

-(void)reValidate;

-(void)vailidateMobile:(NSString*)mobile
               Country:(NSString*)country
              Location:(CGPoint)llcord;


//Verify phone Code
-(BOOL)validCode:(NSString*)code;


//Singleton
+(ServerModel *) sharedManager;

@end
