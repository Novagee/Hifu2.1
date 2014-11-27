//
//  UIHelpers.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/21/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HFGeneralHelpers : NSObject

+ (BOOL)isInternetReachable;


/**
 *  get the text width, this may not be very accurate, need to give 1 or 2 px extra
 *
 *  @param text   string value
 *  @param font   text font
 *  @param height text field height constrain
 *
 *  @return text width
 */
+ (int)getTextWidth:(NSString*)text andFont: (UIFont *)font andHeight:(float)height;

/**
 *  get the text height, this may not be very accurate, need to give 1 or 2 px extra
 *
 *  @param text  string value
 *  @param font  text font
 *  @param width text field width constrain
 *
 *  @return text height
 */
+ (int)getTextHeight:(NSString*)text andFont: (UIFont *)font andWidth:(float)width;

/**
 *  Get attributed Text String
 *
 *  @param text      string value
 *  @param font      text font
 *  @param width     text field width constrain
 *  @param lineSpace line space
 *
 *  @return text height
 */
+ (int)getAttributedTextHeight:(NSString*)text andFont: (UIFont *)font andWidth:(float)width andLineSpace:(float)lineSpace;

/**
 *  get the total line count based on the width limitation
 *
 *  @param text  string value
 *  @param font  text font
 *  @param width text field width constrain
 *
 *  @return total number of lines
 */
+ (int)getTextLineCount:(NSString*)text andFont: (UIFont *)font andWidth:(float)width;

/**
 *  get the theme color for itinerary based on its index
 *
 *  @param index index of itinerary
 *
 *  @return theme color
 */
+ (UIColor *)getItineraryColorForIndex:(NSInteger)index;

/**
 *  check if country code belongs to China
 *
 *  @param countryCode country code
 *
 *  @return yes if it's chinese country code
 */
+ (BOOL)isChinaCountryCode:(NSString *)countryCode;

/**
 *  Get the country name from country code
 *
 *  @param code country code
 *
 *  @return country name
 */
+ (NSString*)countryNameFromCode:(NSString*)code;

/**
 *  show error alert view
 *
 *  @param error the actual error
 */
+ (void)showErrorAlertViewBasedOn:(NSError *)error;

/**
 *  Archive Data to a specific path
 *
 *  @param data
 *  @param path
 */
+ (void)saveData:(id)data toFileAtPath:(NSString *)path;

/**
 *  delete data from a specific path
 *
 *  @param path
 */
+ (void)deleteDataFileAtPath:(NSString *)path;

/**
 *  construct the path of a data based on it's file name
 *
 *  @param fileName
 *
 *  @return entire path string
 */
+ (NSString *)dataFilePath:(NSString *)fileName;

/**
 *  get the data from a specific path
 *
 *  @param filePath
 *
 *  @return data
 */
+ (id)getDataForFilePath:(NSString *)filePath;

/**
 *  Generate an uiimage filled by color
 *
 *  @param color color of image
 *
 *  @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  Generate an uiimage filled by color with an specific size
 *
 *  @param color color of image
 *  @param size  size of image
 *
 *  @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  Get how much time an coupon still have before expire
 *
 *  @param expires expire time
 *
 *  @return actual hours/days before exipres
 */
+ (NSString *)getExpireTimeStringFrom:(NSDate *)expireDate;

/**
 *  Generate Attributed String based on it's fond, color and line space
 *
 *  @param string    string value
 *  @param font      text font
 *  @param textColor text color
 *  @param lineSpace line space
 *
 *  @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)generateAttributedString:(NSString *)string
                                               withFont:(UIFont *)font
                                               andColor:(UIColor *)textColor
                                           andLineSpace:(float)lineSpace;
/**
 *  Show the alert for location service error
 *
 *  @param error the actual error for location serivce
 */
+ (void)handleLocationServiceError:(NSError *)error;

/**
 *  check if location coordinate is in the map visible region
 *
 *  @param mapView            map view
 *  @param locationCoordinate location coordinate
 *
 *  @return yes or no
 */
+ (BOOL)checkMap:(MKMapView *)mapView containLocation:(CLLocationCoordinate2D)locationCoordinate;

/**
 *  Get distance in Kilometers from one location to another
 *
 *  @param fromLocation should be user current location
 *  @param toLocation   to store location
 *
 *  @return distance number in km
 */
+ (CLLocationDistance)distanceInKMFromLocation:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation;

@end
