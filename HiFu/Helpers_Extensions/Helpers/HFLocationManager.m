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
//    if (_failureBlock) {
//        _failureBlock(error);
//    }
    
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

    
	_currentLocation = nil;
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
