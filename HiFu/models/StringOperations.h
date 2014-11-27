//
//  StringOperations.h
//  HiFu
//
//  Created by Rich on 6/30/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringOperations : NSObject

+ (BOOL)stringInArrayContainsUnicode:(NSArray *)params;
+ (BOOL)stringContainsUnicode:(NSString*)string;

+ (BOOL)stringInArrayContainsEmoji:(NSArray *)params;
+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (CGFloat)text: (NSString*)text
     atrributes: (NSDictionary*)attrib
          width: (CGFloat)width;

+ (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text
                                  andWidth: (CGFloat)width;

+ (void) sizeLabel: (UILabel *)label
            toRect: (CGRect) labelRect;

+ (NSString*)countryNameFromCode:(NSString*)code;

+ (int)formattedCountOfString:(NSString*)str;

#pragma mark - unicode text

+(NSString*)encodeEmojiText:(NSString*)emoji;

+(NSString*)decodeEmojiText:(NSString*)emoji;

#pragma mark - remove Whitespace (start & end of string)

+(NSString*)remExtraSpaces:(NSString*)string;

@end
