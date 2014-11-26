//
//  UIHelpers.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/21/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import "HFGeneralHelpers.h"
#import <Reachability.h>

@implementation HFGeneralHelpers

+ (BOOL)isInternetReachable
{
    return [Reachability reachabilityForInternetConnection].isReachable;
}

+ (int)getTextWidth:(NSString*)text andFont: (UIFont *)font andHeight:(float)height {
    CGSize constrain = CGSizeMake(100000, height);
    return [text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:Nil].size.width;
}

+ (int)getTextHeight:(NSString*)text andFont: (UIFont *)font andWidth:(float)width {
    CGSize constrain = CGSizeMake(width, 1000000);
    return [text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:Nil].size.height;
}

+ (int)getAttributedTextHeight:(NSString*)text andFont: (UIFont *)font andWidth:(float)width andLineSpace:(float)lineSpace
{
    if (!text || [text isEqualToString:@""]) {
        return 0;
    }
    
    CGSize constrain = CGSizeMake(width, 1000000);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 (NSString*)kCTParagraphStyleAttributeName: style};
    return [text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:Nil].size.height;
}

+ (int)getTextLineCount:(NSString*)text andFont: (UIFont *)font andWidth:(float)width {
    CGSize constrain = CGSizeMake(width, 1000000);
    return ceil([text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:Nil].size.height / font.lineHeight );
}

+ (UIColor *)getItineraryColorForIndex:(NSInteger)index
{
    if (index % 6 == 0) {//6的倍数
        return HFCDayBackgroundColorSix;
    }
    else if (index % 6 == 1) {//6x + 1
        return HFCDayBackgroundColorOne;
    }
    else if (index % 6 == 2) {//6x + 2
        return HFCDayBackgroundColorTwo;
    }
    else if (index % 6 == 3) {//6x + 3
        return HFCDayBackgroundColorThree;
    }
    else if (index % 6 == 4) {// 6x + 4
        return HFCDayBackgroundColorFour;
    }
    else if (index % 6 == 5) {// 6x + 5
        return HFCDayBackgroundColorFive;
    }
    else
    {
        return [UIColor blackColor];
    }
}

+ (BOOL)isChinaCountryCode:(NSString *)countryCode
{
    return [countryCode isEqualToString:@"86"] ? YES : NO;
}

+ (NSString*)countryNameFromCode:(NSString*)code
{
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

+ (void)showErrorAlertViewBasedOn:(NSError *)error
{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"test"
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)saveData:(id)data toFileAtPath:(NSString *)path
{
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}

+ (void)deleteDataFileAtPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
	BOOL exists = [fm fileExistsAtPath:path];
	if (exists) [fm removeItemAtPath:path error:nil];
}

+ (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    return [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat", fileName]];
}

+ (id)getDataForFilePath:(NSString *)filePath
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [HFGeneralHelpers imageWithColor:color andSize:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)getExpireTimeStringFrom:(NSDate *)expireDate
{
    if (!expireDate) {
        return nil;
    }
    
    int timeBeforeExpire = [[expireDate dateByAddingTimeInterval:60*60*24] timeIntervalSinceNow];
    if (timeBeforeExpire < 0) {
        return @"已过期";
    }
    
    int daysTotal = (int)((timeBeforeExpire)/60/60/24);
    
    return daysTotal == 0 ? [NSString stringWithFormat:@"还剩%i小时",timeBeforeExpire/60/60] :
                            [NSString stringWithFormat:@"还剩%i天",daysTotal];
}

+ (NSMutableAttributedString *)generateAttributedString:(NSString *)string
                                               withFont:(UIFont *)font
                                               andColor:(UIColor *)textColor
                                           andLineSpace:(float)lineSpace
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentJustified;
    [mutableAttributedString addAttribute:(NSString*)kCTParagraphStyleAttributeName value:style range:NSMakeRange(0, [mutableAttributedString length])];
    [mutableAttributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [mutableAttributedString length])];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [mutableAttributedString length])];
    [mutableAttributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:0] range:NSMakeRange(0, [mutableAttributedString length])];
    return mutableAttributedString;
}

+ (void)handleLocationServiceError:(NSError *)error
{
    NSString *alertMessage = @"";
    
    if ([error domain] == kCLErrorDomain)
    {
        switch (error.code)
        {
            case kCLErrorDenied:
                alertMessage = @"获取GPS信息服务被关闭了，请到设置->隐私中打开";
                break;
            default:
                alertMessage = @"获取GPS信息服务暂时无法使用，请稍后再试";
                break;
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:alertMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

+ (BOOL)checkMap:(MKMapView *)mapView containLocation:(CLLocationCoordinate2D )locationCoordinate
{
    MKCoordinateRegion region = mapView.region;
    
    CLLocationCoordinate2D center = region.center;
    CLLocationCoordinate2D northWestCorner, southEastCorner;
    
    northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
    northWestCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
    southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
    southEastCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
    
    if (locationCoordinate.latitude  >= northWestCorner.latitude &&
        locationCoordinate.latitude  <= southEastCorner.latitude &&
        
        locationCoordinate.longitude >= northWestCorner.longitude &&
        locationCoordinate.longitude <= southEastCorner.longitude)
    {
        return YES;
        
    }
    else
    {
        return NO;
    }
}

+ (CLLocationDistance)distanceInKMFromLocation:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation
{
	CLLocationDistance distanceInKM = [fromLocation distanceFromLocation:toLocation] / 1000.00;
	return distanceInKM;
}

@end
