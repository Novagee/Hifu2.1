//
//  LowNetModel.h
//  HiFu
//
//  Created by Rich on 6/12/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFBaseAPIv2 : NSObject
@property (nonatomic) int retryCount;
@property (nonatomic) BOOL sentOfflineAlert;

+ (instancetype)sharedInstance;

//GET
- (id)HFRequestGETWithURL:(NSString *)urlPath
               parameters:(id)params
                  success:(void(^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

//POST
-(id)HFRequestPOSTWithURL:(NSString*)postPath
               parameters:(id)params
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

-(id)HFRequestPOSTWithURL:(NSString *)postPath
            withImageData:(NSData *)imageData
               parameters:(id)params
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

-(id)HFRequestDELETEWithURL:(NSString*)postPath
                 parameters:(NSDictionary*)params
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

#warning 下面所有的Methods必须全部重写

-(BOOL)checkNetorkConnectionWithPopup:(BOOL)popup;


-(void)doGETWithURL:(NSURL*)url
         Completion:(void (^)(id responseObject, bool success))completion;

-(void)doPOSTWithURL:(NSString*)postPath
          Parameters:(id)params
            plainRes:(BOOL)plainRes
          Completion:(void (^)(id responseObject, bool success))completion;



-(void)doDELETEWithURL:(NSString*)postPath
            Parameters:(NSDictionary*)params
            Completion:(void (^)(id responseObject, bool success))completion;
@end
