//
//  ObjectHelper.h
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectHelper : NSObject

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)aClass;
+ (NSArray *)propertyNames:(Class)aClass;

@end
