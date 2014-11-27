//
//  NumOperations.m
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFPhoneNumberHelpers.h"
#import "ServerModel.h"
#import "HFGeneralHelpers.h"
#import "UserServerApi.h"

#warning Richard的神秘的文件。不理解为什么独立存在这里。必须全部重新审核重组翻新
//static const int us_num_length = 10;
//static const int china_num_length = 11;

@implementation HFPhoneNumberHelpers

+(BOOL)inputContainsNums:(NSString*)inputNum{
    NSString *str = inputNum;// some string to check for at least one digit and a length of at least 7
    if ([str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location != NSNotFound) {
        return YES;  // this matches the criteria
    }
    return NO;
}

+(NSString*)removeSpaces:(NSString*)mobile{
    NSString  * retString = mobile;
    retString = [retString stringByReplacingOccurrencesOfString: @" " withString:@""];
    return retString;
}

+(NSString*)checkNumberFormat:(NSString*)mobile{
    
    if (mobile.length <1) {
        return nil;
    }
    if (![[mobile substringToIndex:1] isEqualToString:@"1"] && [HFGeneralHelpers isChinaCountryCode:[UserServerApi sharedInstance].userCountryCode]) {
        return @"手机号码格式错误，请重新输入";
    }
    if  (![mobile rangeOfString:@"+"].location == NSNotFound) {
        return @"Invalid Formart( + is not valid Number)";
    }
    if  (![mobile rangeOfString:@"*"].location == NSNotFound) {
        return @"Invalid Formart( * is not valid Number)";
    }
    if  (![mobile rangeOfString:@"#"].location == NSNotFound) {
        return @"Invalid Formart( # is not valid Number)";
    }
    if  (![mobile rangeOfString:@","].location == NSNotFound) {
        return @"Invalid Formart( , is not valid Number)";
    }
    if  (![mobile rangeOfString:@";"].location == NSNotFound) {
        return @"Invalid Formart( ; is not valid Number)";
    }
    return  nil;
}


+(NSString*)formatNumberForSpaces:(NSString*)mobile{
    
    NSString  * retString = mobile;
    retString = [retString stringByReplacingOccurrencesOfString: @"+" withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString: @"*" withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString: @"#" withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString: @"," withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString: @";" withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString: @"_" withString:@""];
    retString = [retString stringByReplacingOccurrencesOfString: @" " withString:@""];
    

    if (retString.length > 3) {
        NSString *swap= [retString substringWithRange:NSMakeRange(3, 1)];
        retString = [retString stringByReplacingCharactersInRange:NSMakeRange(3, 1)
                                                       withString:[@" " stringByAppendingString:swap]];
    }
    
    int secondSpace = 8;
    if (![HFGeneralHelpers isChinaCountryCode:[UserServerApi sharedInstance].userCountryCode]) {
        secondSpace--;
    }
    
    if (retString.length > secondSpace) {
        NSString *swap= [retString substringWithRange:NSMakeRange(secondSpace, 1)];
        retString = [retString stringByReplacingCharactersInRange:NSMakeRange(secondSpace, 1)
                                                       withString:[@" " stringByAppendingString:swap]];
    }
    
    return retString;
}

+ (NSString*)carrierFromNumber:(NSString*)mobile
{
    BOOL threeOnly = NO;
    if (mobile.length < 3) {
        return nil;
    }
    
    if (mobile.length < 4) {
        threeOnly = YES;
    }
    
    NSNumber *three = [NSNumber numberWithInt:[[mobile substringToIndex:3] intValue]];
    
    NSNumber *four;
    
    if (!threeOnly) {
        four= [NSNumber numberWithInt:[[mobile substringToIndex:4] intValue]];
    }
    
    if ([three isEqualToNumber:@177]) {
        return @"BluePack";
    }
    if (threeOnly && [three isEqualToNumber:@1349]) {
        return @"ChinaSat";
    }
    
    NSArray *unicom = @[@130,@131,@132,@145,@155,@156,@185,@186];

    NSArray *telecom  = @[@133, @153, @180, @181, @189];
    NSArray *cmobile4 = @[@1340,@1341,@1342,@1343,@1344,@1345,@1346,@1347,@1348];
    NSArray *cmobile3 = @[@135, @136, @137, @138, @139, @147, @150, @151, @152, @157,
                          @158, @159, @182, @183, @187, @188];
    
    if (threeOnly) {
        for (NSNumber*code in cmobile4) {
            if ([ four isEqualToNumber:code]) {
                return @"中国移动";
            }
        }
    }
    
    for (NSNumber*code in cmobile3) {
        if ([three isEqualToNumber:code]) {
            return @"中国移动";
        }
    }
    
    for (NSNumber*code in unicom) {
        if ([three isEqualToNumber:code]) {
            return @"中国联通";
        }
    }
    
    for (NSNumber*code in telecom) {
        if ([three isEqualToNumber:code]) {
            return @"中国 Telecom";
        }
    }
    
    return nil;
    
}
@end
