//
//  TransactionRecordObject.h
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"
@class CouponObject;
@interface TransactionRecordObject : BaseObject

@property (nonatomic, strong) CouponObject *coupon;
@property (nonatomic, strong) NSDate *transactionTime;

@end
