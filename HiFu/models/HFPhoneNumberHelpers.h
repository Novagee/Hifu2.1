//
//  NumOperations.h
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#warning 这个file需要重新写。完全不理解存在的意义
@interface HFPhoneNumberHelpers : NSObject

+(NSString*)carrierFromNumber:(NSString*)mobile;
+(NSString*)checkNumberFormat:(NSString*)mobile;

+(NSString*)removeSpaces:(NSString*)mobile;
+(NSString*)formatNumberForSpaces:(NSString*)mobile;
@end
