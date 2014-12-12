//
//  LowNetModel.m
//  HiFu
//
//  Created by Rich on 6/12/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <AFNetworking/AFNetworking.h>

#import "HFBaseAPIv2.h"
#import "EasyData.h"
#import "Reachability.h"

static  NSString* authUser  = @"DDF98F5A1B722";
static  NSString* authPass  = @"632F132525EFB5495889441E3AF7F";
static const int retryLimit = 2;

@implementation HFBaseAPIv2

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static HFBaseAPIv2 *obj = nil;
    
    dispatch_once(&pred, ^{ obj = [[self alloc] init]; });
    return obj;
}


#pragma mark - Request Construct Metods

-(NSMutableURLRequest*)constructRequestWithUrl:(NSString *)urlPath
                                    parameters:(id)params
                                    httpMethod:(NSString *)httpMethod
{
#warning 当把Richard的Api全部清理完就不应该再用到这个IF，应该要去除掉。
    NSMutableURLRequest *request;
    if (!params) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        request = [manager.requestSerializer requestWithMethod:httpMethod
                                                     URLString:urlPath
                                                    parameters:params
                                                         error:nil];
    }
    
    NSData* authData = [[[NSString
                          stringWithFormat:@"%@:%@",authUser,authPass]
                         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                        dataUsingEncoding: NSASCIIStringEncoding];
    
    NSLog(@"auth string : %@", [[NSString stringWithFormat:@"%@:%@",authUser,authPass] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSString *finalAuth = [NSString stringWithFormat:@"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:finalAuth forHTTPHeaderField:@"Authorization"];
    
    return request;
}

#pragma mark - Base Api Calls
- (id)HFRequestGETWithURL:(NSString *)urlPath
               parameters:(id)params
                  success:(void(^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure
{
    NSError *reachabilityError = [self checkReachability];
    if (reachabilityError) {
        failure(reachabilityError);
        return nil;
    }
    
    NSURLRequest* request = [self constructRequestWithUrl:urlPath parameters:params httpMethod:@"GET"];
    NSLog(@"HF GET Request Path: %@", [request.URL absoluteString]);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = nil;
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [op start];
    return op;
}

- (id)HFRequestPOSTWithURL:(NSString *)postPath
                parameters:(id)params
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure
{
    NSError *reachabilityError = [self checkReachability];
    if (reachabilityError) {
        failure(reachabilityError);
        return nil;
    }
    NSLog(@"HF POST Request Path: %@", postPath);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (params)
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:authUser
                                                              password:authPass];
    return [manager POST:postPath
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                     self.retryCount = 0;
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                     failure(error);
                 }];
    
}

-(id)HFRequestPOSTWithURL:(NSString *)postPath
            withImageData:(NSData *)imageData
               parameters:(id)params
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure
{
    NSError *reachabilityError = [self checkReachability];
    if (reachabilityError) {
        failure(reachabilityError);
        return nil;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:authUser
                                                              password:authPass];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    return [manager POST:postPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData != nil)
            [formData appendPartWithFileData:imageData
                                        name:@"pictureUrl"
                                    fileName:@"pictureUrl"
                                    mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}

-(id)HFRequestDELETEWithURL:(NSString*)postPath
                 parameters:(NSDictionary*)params
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure
{
    NSError *reachabilityError = [self checkReachability];
    if (reachabilityError) {
        failure(reachabilityError);
        return nil;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:authUser
                                                              password:authPass];
    
    return [manager DELETE:postPath
                parameters:params
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       success(responseObject);
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       failure(error);
                   }];
}

#pragma mark - Helper Methods
- (NSError *)checkReachability{
    if (![Reachability reachabilityForInternetConnection].isReachable) {
        NSError *error = [[NSError alloc]initWithDomain:@"HFNetworkNotReachable"
                                                   code:9999
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"ErrorBody", @"您的网络不是特别理想，请稍后尝试", nil]];
        return error;
    }
    else
        return nil;
}

#pragma mark - direct network calls


-(void)doPOSTWithURL:(NSString*)postPath
          Parameters:(id)params
            plainRes:(BOOL)plainRes
          Completion:(void (^)(id responseObject, bool success))completion{
    
    
    if (![self checkNetorkConnectionWithPopup:YES]) {
        completion(nil,NO);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (params) {
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    }
    
    if (plainRes) {
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain;charset=ISO-8859-1",
                                                             @"text/plain",
                                                             @"text/html",
                                                             @"text/json; application/json; charset=utf-8",
                                                             nil];
    }
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:authUser
                                                              password:authPass];
    
    [manager POST:postPath
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(responseObject, YES);
              self.retryCount = 0;
              
              // NSLog(@"JSON: %@", responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSError *retError = [NSError errorWithDomain:error.domain
                                                      code:[operation.response statusCode]
                                                  userInfo:error.userInfo];
              
              if (self.retryCount<retryLimit) {
                  NSLog(@"RETRYING CREATE USER");
                  [self doPOSTWithURL:postPath
                           Parameters:params
                             plainRes:plainRes
                           Completion:completion];
              }
              else{
                  [self jsonFailureAlertMess:@"post failed" Error:retError];
                  completion(nil,NO);
              }
              
              self.retryCount ++;
          }];
}



-(void)doGETWithURL:(NSURL*)url
         Completion:(void (^)(id responseObject, bool success))completion{
    
    if (![self checkNetorkConnectionWithPopup:YES]) {
        completion(nil,NO);
        return;
    }
    
    NSURLRequest* request = [self constructRequestWithUrl:[url absoluteString] parameters:nil httpMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer     = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                        id responseObject) {
        
        self.retryCount   = 0;
        //  NSLog(@"JSON: %@", responseObject);
        completion(responseObject, YES);
        
    } failure:^(AFHTTPRequestOperation *operation,
                NSError *error) {
        NSError *retError = [NSError errorWithDomain:error.domain
                                                code:[operation.response statusCode]
                                            userInfo:error.userInfo];
        if (self.retryCount<retryLimit) {
            [self doGETWithURL:url
                    Completion:completion];
        }
        else{
            [self jsonFailureAlertMess:@"get failed" Error:retError];
            completion(nil,NO);
        }
        self.retryCount ++;
        completion(nil, NO);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}


-(void)doDELETEWithURL:(NSString*)postPath
            Parameters:(NSDictionary*)params
            Completion:(void (^)(id responseObject, bool success))completion{//WithCompletion:(void (^)(id responseObject, bool success))completion{
    
    
    if (![self checkNetorkConnectionWithPopup:YES]) {
        completion(nil,NO);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain;charset=ISO-8859-1",@"text/plain",@"text/html",@"text/json", nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:authUser
                                                              password:authPass];
    
    
    [manager DELETE:postPath
         parameters:params
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                completion(responseObject, YES);
                self.retryCount =0;
                //                NSLog(@"JSON: %@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR RETURNED AS %i",[operation.response statusCode]);
                NSError *retError = [NSError errorWithDomain:error.domain
                                                        code:[operation.response statusCode]
                                                    userInfo:error.userInfo];
                if (self.retryCount<retryLimit) {
                    NSLog(@"RETRYING CREATE USER");
                    [self doDELETEWithURL:postPath
                               Parameters:params
                               Completion:completion];
                }
                else{
                    [self jsonFailureAlertMess:@"delete failed" Error:retError];
                    completion(nil,NO);
                }
                
                self.retryCount ++;
            }];
}



#pragma mark - Errors Handling -

//MOVE this to separate class

-(void)jsonFailureAlertMess:(NSString*)text
                      Error:(NSError*)error{
    // return;
    if (self.sentOfflineAlert) {
        return;
    }
    //_sentOfflineAlert=YES;
    NSString *message=@"您的网络不是特别理想，请稍后尝试";
    
    //    if( text ){
    //        message = [NSString stringWithFormat:@"%@\n%@",message,text];
    //    }
    //    if( error ){
    //        message = [NSString stringWithFormat:@"%@\n错误：%@",message,error.localizedDescription];
    //    }
    
    if ([self checkNetorkConnectionWithPopup:NO]) {
        
        
        if ((error.code == 404 || error.code == 500)) {
            message =@"内部服务器错误";
        }
        else {
            NSString*currentView = [EasyData getDataWithKey:@"currentView"];
            message =[NSString stringWithFormat:@"%@暂时无法显示",currentView];
        }
        
        
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil , nil];
    [alert show];
}


-(BOOL)checkNetorkConnectionWithPopup:(BOOL)popup{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        //        NSLog(@"There IS NO internet connection");
        if (popup) {
            [self jsonFailureAlertMess:@"no internet" Error:nil];
        }
        return NO;
    }
    else {
        //        NSLog(@"There IS internet connection");
        return YES;
    }
}


- (BOOL)checkNetworkConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus == NotReachable ? NO : YES;
}


#pragma mark - init


-(id)init{
    self = [super init];
    if (self) {
        _retryCount = 0;
        _sentOfflineAlert = NO;
    }
    return self;
}
@end
