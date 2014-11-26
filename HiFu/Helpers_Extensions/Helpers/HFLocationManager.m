//
//  HFLocationManager.m
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

static const NSUInteger kDistanceFilter = 5;
static const NSUInteger kHeadingFilter = 30;

#import "HFLocationManager.h"

@implementation HFLocationManager

+ (HFLocationManager *)sharedInstance
{
    static dispatch_once_t pred;
    static HFLocationManager *obj = nil;
	
    dispatch_once(&pred, ^{ obj = [[self alloc] init]; });
    return obj;
}

- (instancetype)init{
    if ((self = [super init])) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kDistanceFilter;
            self.locationManager.headingFilter = kHeadingFilter;
        }
    }
    return self;
}

- (void)startUpdatingLocation{
    
    NSLog(@"Debug Mark **********************");
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    [_locationManager startUpdatingLocation];
    if (floor(NSFoundationVersionNumber > 1047.25)) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    NSLog(@"AAAA:start getting the location!");

}

- (void)startUpdatingLocation:(void (^)())success failure:(void(^)(NSError *error))failure
{
    
    _successBlock = success;
    _failureBlock = failure;
    
    NSLog(@"Start updating location ");
    
    [self startUpdatingLocation];
    
    
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"AAAAA:sucess get the location!");
    if(locations && locations.count > 0)        //in thise case, we found location data
    {
        [HFLocationManager sharedInstance].currentLocation = [locations objectAtIndex:locations.count - 1];
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
        if (_successBlock) {
            _successBlock();
        }
    }
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failure update");
    
	_currentLocation = nil;
    
    if (_failureBlock) {
        _failureBlock(error);
    }
        
}

- (BOOL)locationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

- (CLAuthorizationStatus)locationServiceStatus
{
    if ([self locationServicesEnabled]) {
        return kCLAuthorizationStatusDenied;
    } else {
        return [CLLocationManager authorizationStatus];
    }
}

@end
