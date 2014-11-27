//
//  StringOperations.m
//  HiFu
//
//  Created by Rich on 6/30/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "StringOperations.h"

@implementation StringOperations

#pragma mark - remove Whitespace (start & end of string)

+(NSString*)remExtraSpaces:(NSString*)string{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

#pragma mark - unicode text

+(NSString*)encodeEmojiText:(NSString*)emoji{
    NSString *uniText = [NSString stringWithUTF8String:[emoji UTF8String]];
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodMsg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] ;
    return goodMsg;
}

+(NSString*)decodeEmojiText:(NSString*)emoji{
    const char *jsonString = [emoji UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    return goodMsg;
}


#pragma mark - unicode

+ (BOOL)stringInArrayContainsUnicode:(NSArray *)params{
    for (NSString*string in params) {
        if ([StringOperations stringContainsUnicode:string]) {
            return YES;
        }
    }
    return NO;
}

+(BOOL)stringContainsUnicode:(NSString*)string{
    NSData *data = [string dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if ([goodValue rangeOfString:@"\\u"].location == NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - emoji
+ (BOOL)stringInArrayContainsEmoji:(NSArray *)params{
    for (NSString*string in params) {
        if ([StringOperations stringContainsEmoji:string]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

#pragma mark - text heights
+(CGFloat)text: (NSString*)text
    atrributes: (NSDictionary*)attrib
         width: (CGFloat)width{
    
    NSMutableAttributedString *displayText = [[NSMutableAttributedString alloc] initWithString:text];
    [displayText setAttributes:attrib range:NSMakeRange(0, text.length)];
    
    return  [StringOperations textViewHeightForAttributedText:displayText andWidth:width];
    
}

+ (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text
                                  andWidth: (CGFloat)width {
    
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    NSLog(@"height of comment %f",size.height);
    return size.height;
}

#pragma mark -

+ (int)formattedCountOfString:(NSString*)str
{

        NSString* const pattern = @"\\p{script=han}";
        NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                          options:0
                                                                            error:nil];
        NSRange range = NSMakeRange(0, [str length]);
        int charsCount = [regex numberOfMatchesInString:str
                                                options:0
                                                  range:range];
    
        int remainder = (str.length - charsCount) / 3;
    
        return charsCount+remainder;
}


+ (NSString*)countryNameFromCode:(NSString*)code{
    int cc = [code intValue];
    switch (cc) {
        case 86:
            return @"China";
            break;
        case 1:
            return @"US";
            break;
        default:
            return @"Unknown";
            break;
    }
}


+ (void) sizeLabel: (UILabel *)label
            toRect: (CGRect) labelRect  {
    
    // Set the frame of the label to the targeted rectangle
    label.frame = labelRect;
    
    // Try all font sizes from largest to smallest font size
    int fontSize = 300;
    int minFontSize = 5;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    
    do {
        // Set current font size
        label.font = [UIFont fontWithName:label.font.fontName size:fontSize];
        
        // Find label size for current font size
        CGRect textRect = [[label text] boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:label.font}
                                                       context:nil];
        
        CGSize labelSize = textRect.size;
        
        // Done, if created label is within target size
        if( labelSize.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        fontSize -= 2;
        
    } while (fontSize > minFontSize);
}

@end
