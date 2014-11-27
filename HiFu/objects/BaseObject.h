//
//  BaseObject.h
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseObject :  NSObject <NSCoding>

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemDescription;

- (id)initWithDictionary:(NSDictionary *)dictionary;

//Dictionary equivalent of Object
//assuming properties are PLIST compliant
- (NSDictionary *) dictionary;

@end
