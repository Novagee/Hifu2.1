//
//  HFCouponMapViewController.m
//  HiFu
//
//  Created by Yin Xu on 8/7/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "HFCouponMapViewController.h"

//Map Annotation
#import "HFBasicMapAnnotation.h"
#import "HFMapCalloutView.h"

//Objects
#import "MerchantObject.h"
#import "CouponObject.h"
#import "StoreObject.h"
#import "WorkHourObject.h"

//Apis
#import "MerchantsServerApi.h"

//Helpers
#import "HFLocationManager.h"
#import "HFGeneralHelpers.h"

#define defaultRadius 30000

@interface HFCouponMapViewController ()
{
    NSMutableArray *storesArray;
    HFMapCalloutView *calloutView;
    NSTimer *refreshTimer;
    id requestConnection;
    BOOL isFirstMapMovingDone;
    CLLocation *currentCenterLocation;
}

@end

@implementation HFCouponMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewComponents];
    if ([HFLocationManager sharedInstance].currentLocation) {
        [self performSelector:@selector(setMapCenterPoint)
                   withObject:nil
                   afterDelay:0.2];
        currentCenterLocation = [HFLocationManager sharedInstance].currentLocation;
        [self loadStores];
    }
    else
    {
        [[HFLocationManager sharedInstance] startUpdatingLocation:^{
            [self performSelector:@selector(setMapCenterPoint)
                       withObject:nil
                       afterDelay:0.2];
            currentCenterLocation = [HFLocationManager sharedInstance].currentLocation;
            [self loadStores];
        } failure:^(NSError *error) {
            [HFGeneralHelpers handleLocationServiceError:error];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (([[HFLocationManager sharedInstance] locationServiceStatus]) != kCLAuthorizationStatusAuthorized) {
        // Invoke sysytem alertView
        [[HFLocationManager sharedInstance] startUpdatingLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[HFLocationManager sharedInstance] stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewComponents
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];
    self.titleNameLabel.hidden = NO;
    if (self.coupon.merchant.nameCn) {
        self.titleNameLabel.text = self.coupon.merchant.nameCn;
        self.titleNameLabel.font = HeitiSC_Medium(16);
    }
    else
    {
        self.titleNameLabel.text = self.coupon.merchant.name;
        self.titleNameLabel.font = HelveticaNeue_Regular(16);
    }
    self.logoImageView.image = self.logoImage;
    self.couponShortTitleLabel.text = self.coupon.shortTitleCN;
    self.couponExpireLabel.text = [HFGeneralHelpers getExpireTimeStringFrom:self.coupon.expiredAt];
}

- (void)setMapCenterPoint
{
    self.mapView.showsUserLocation = YES;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance ([HFLocationManager sharedInstance].currentLocation.coordinate, defaultRadius, defaultRadius);
    [self.mapView setRegion:region animated:YES];
    [self performSelector:@selector(setFirstMapMovingDone) withObject:nil afterDelay:1.5];
}

- (void)setFirstMapMovingDone
{
    isFirstMapMovingDone = YES;
}

#pragma mark - API methods
- (void)loadStores
{
    requestConnection = [MerchantsServerApi getStoreForMerchant:self.coupon.itemId
                               withLocation:currentCenterLocation
                                 inDistance:25
                                    success:^(id stores){
                                        // we need to check if there are existing annotation on the map
                                        // if yes, find all annotation that is out of map region, remove it
                                        for (HFBasicMapAnnotation *annotation in self.mapView.annotations) {
                                            if (![annotation isKindOfClass:[MKUserLocation class]] && ![HFGeneralHelpers checkMap:self.mapView containLocation:annotation.coordinate])
                                            {
                                                [storesArray removeObject:annotation.store];
                                                [self.mapView removeAnnotation:annotation];
                                            }
                                        }
                                        
                                        if (storesArray && [storesArray count] > 0) // if there are remain annotation
                                        {
                                            NSMutableArray *tempArray = [storesArray mutableCopy];
                                            for (NSDictionary *dict in stores) {
                                                StoreObject *s = [[StoreObject alloc] initWithDictionary:dict];
                                                for (StoreObject *store in storesArray) {
                                                    // check if there is anyone in the return result that match the store in our existing store list
                                                    // if yes, we want to skip it, so we won't have duplicate annotation
                                                    // and we wont see drop pin animation for the remain ones
                                                    if ([store.latitude doubleValue] != [s.latitude doubleValue] ||
                                                        [store.longitude doubleValue] != [s.longitude doubleValue]) {
                                                        [tempArray addObject:s];
                                                        HFBasicMapAnnotation *annotation = [[HFBasicMapAnnotation alloc] initWithLatitude:[s.latitude floatValue] andLongitude:[s.longitude floatValue] andStore:s];
                                                        [self.mapView addAnnotation:annotation];
                                                    }
                                                }
                                            }
                                            storesArray = tempArray;
                                        }
                                        else // if there is no remain annoation or it's the first load
                                        {
                                            storesArray = [NSMutableArray new];
                                            for (NSDictionary *dict in stores) {
                                                StoreObject *s = [[StoreObject alloc] initWithDictionary:dict];
                                                [storesArray addObject:s];
                                                HFBasicMapAnnotation *annotation = [[HFBasicMapAnnotation alloc] initWithLatitude:[s.latitude floatValue] andLongitude:[s.longitude floatValue] andStore:s];
                                                [self.mapView addAnnotation:annotation];
                                            }
                                        }
                                    } failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                    }];
}

#pragma mark - MKMapView Delegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        HFBasicMapAnnotation *annotation = self.mapView.selectedAnnotations[0];
        calloutView = [[[NSBundle mainBundle] loadNibNamed:@"HFMapCalloutView"
                                                     owner:self
                                                   options:nil] objectAtIndex:0];
        calloutView.alpha = 0.0;
        [HFUIHelpers roundCornerToHFDefaultRadius:calloutView.topWrapperView];

        int heightDifference = 0;
        
        NSString *storeFullAddress = [NSString stringWithFormat:@"%@, %@ %@", annotation.store.address, annotation.store.city, annotation.store.state];
        int storeAddressHeight = [HFGeneralHelpers getTextHeight:storeFullAddress andFont:calloutView.storeAddressLabel.font andWidth:calloutView.storeAddressLabel.width] + 2;
        if (storeAddressHeight > 30) {
            calloutView.storeAddressLabelHeightConstraint.constant = storeAddressHeight;
            heightDifference = heightDifference + storeAddressHeight - 30;
        }
        else
        {
            calloutView.storeAddressLabelHeightConstraint.constant = 30;
        }
        calloutView.storeAddressLabel.text = storeFullAddress;
        
        if ([HFLocationManager sharedInstance].currentLocation) {
            double distance = [HFGeneralHelpers distanceInKMFromLocation:[HFLocationManager sharedInstance].currentLocation toLocation:[[CLLocation alloc] initWithLatitude:annotation.latitude longitude:annotation.longitude]];
            calloutView.distanceLabel.text = distance < 100 ? [NSString stringWithFormat:@"%.2f", distance] : [NSString stringWithFormat:@"%.1f", distance];
        }
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:now];
        NSUInteger weekdayToday = [components weekday];
        BOOL isTodayOpen = NO;
        for (WorkHourObject *h in annotation.store.dayWorkHours) {
            if ([h.weekDay integerValue] == weekdayToday) {
                isTodayOpen = YES;
                break;
            }
        }
        
        if (!isTodayOpen) {
            calloutView.storeOpeningTimeLabel.text = @"今日休息，不开";
        }
        else
        {
            WorkHourObject *storeHour = [annotation.store.dayWorkHours objectAtIndex:weekdayToday];
            NSString *openTime = [NSString stringWithFormat:@"%@:%@", [storeHour.openHour substringToIndex:2], [storeHour.openHour substringFromIndex:2]];
            NSString *closeTime = [NSString stringWithFormat:@"%@:%@", [storeHour.closeHour substringToIndex:2], [storeHour.closeHour substringFromIndex:2]];
            calloutView.storeOpeningTimeLabel.text = [NSString stringWithFormat:@"开业时间: 今天%@ - %@", openTime, closeTime];
        }
        
        calloutView.height = calloutView.height + heightDifference;
        calloutView.center = CGPointMake(view.bounds.size.width * 0.5f - 8, - calloutView.bounds.size.height * 0.5f);
        
        [view addSubview:calloutView];
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            calloutView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (calloutView) {
        [calloutView removeFromSuperview];
        calloutView = nil;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
    newAnnotation.image = [UIImage imageNamed:@"map_pin"];
    newAnnotation.animatesDrop = YES;
    newAnnotation.canShowCallout = NO;
    [newAnnotation setSelected:YES animated:YES];
    return newAnnotation;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    CLLocationDistance distance = [currentCenterLocation distanceFromLocation:newCenter];
    // if it's not the first map zoom in animation, and the center has been moved a signification distance
    // we want to start the timer
    if (isFirstMapMovingDone && distance > 10000) {
        currentCenterLocation = newCenter;
        [self restartTimer];
    }
}

- (void)restartTimer
{
    // every time when we start the timer
    // we want to invalidate the existing one, and cancel the unfinished request
    [refreshTimer invalidate];
    if(requestConnection)
    {
        [requestConnection cancel];
        requestConnection = nil;
    }

    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self
                                                  selector:@selector(loadStores)
                                                userInfo:nil repeats:NO];
}

@end
