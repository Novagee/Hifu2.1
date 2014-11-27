//
//  HFLocationManager.h
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HFLocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocation *_lastSavedLocation;
    CLLocation *_currentLocation;
    void (^_successBlock)();
    void (^_failureBlock)();
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;


+ (HFLocationManager *)sharedInstance;
- (void)startUpdatingLocation;
- (void)startUpdatingLocation:(void (^)())success failure:(void(^)(NSError *error))failure;
- (void)stopUpdatingLocation;
- (BOOL)locationServicesEnabled;
- (CLAuthorizationStatus)locationServiceStatus;

@end
