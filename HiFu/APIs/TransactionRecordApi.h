//
//  TransactionRecordApi.h
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionRecordApi : NSObject

+ (void)getTransactionRecordsForUser:(NSString *)userId
                    success:(void (^)(id transactionRecords))successBlock
                    failure:(void (^)(NSError * error))failureBlock;
@end
