//
//  CommentObject.h
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "BaseObject.h"

@interface CommentObject : BaseObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *avatarNum;
@property (nonatomic, strong) NSString *userAlias;

@end
