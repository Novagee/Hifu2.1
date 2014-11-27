//
//  TransactionRecordApi.m
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "TransactionRecordApi.h"

#import "HFBaseApi.h"

@implementation TransactionRecordApi

+ (void)getTransactionRecordsForUser:(NSString *)userId
                             success:(void (^)(id transactionRecords))successBlock
                             failure:(void (^)(NSError * error))failureBlock
{
    //eg: http://54.183.40.21:8080/restful/transaction/40
    NSString *path = [NSString stringWithFormat:@"%@/transaction/%@", HF_API_PATH_OLD, userId];
    
    [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                         parameters:nil
                                            success:^(id responseObject) {
                                                successBlock([responseObject objectForKey:@"transactions"]);
                                            }
                                            failure:^(NSError *error) {
                                                NSLog(@"%@", error);
                                                
                                            }];

}


@end
