//
//  EasyData.h
//  HiFu
//
//  Created by Rich on 6/5/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasyData : NSObject
+(id)getDataWithKey:(id)key;
+(void)setData:(id)data forKey:(NSString *)key;
@end
