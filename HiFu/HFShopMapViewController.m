//
//  HFMapViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFShopMapViewController.h"
#import "HFRangeViewController.h"
#import "HFShopListViewController.h"
#import "HFShopDetailViewController.h"
#import "HFWifiViewController.h"
#import "HFHotTeaViewController.h"
#import "HFChineseHelpViewController.h"
#import "StoreObject.h"
#import "HFLocationManager.h"
#import <AFNetworking/AFNetworking.h>
#import "MapPinView.h"
#import "SVProgressHUD.h"
#import "HFStoreServerApi.h"
#import "CouponObject.h"
#import "HFUserApi.h"
#import "HFCategory.h"
#import "HFBrand.h"
#import "HFGeneralHelpers.h"
#import "HFUIHelpers.h"

CGFloat const defaultRadius=100000;

@interface HFShopMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSTimer *refreshTimer;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (assign, nonatomic) BOOL isLiked;
@property (strong, nonatomic) NSMutableArray *storesArray;
@property (weak, nonatomic) IBOutlet UIImageView *mapDetailImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameCN;
@property (weak, nonatomic) IBOutlet UILabel *storeNameEN;
@property (weak, nonatomic) IBOutlet UILabel *storeLocationName;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) CLLocation *currentCenterLocation;
@property (strong, nonatomic) UIView *animationBottom;
@property (assign, nonatomic) BOOL isRangeViewShow;
@property (assign, nonatomic) BOOL isFirstMapMovingDone;
@property (strong, nonatomic) NSArray *titleLabelDatas;
@property (weak, nonatomic) IBOutlet UIView *storeInfoView;
@property (weak, nonatomic) IBOutlet UIView *titleSubButtonBottom;

@property (strong, nonatomic) NSMutableDictionary *openingTimes;
@property (copy, nonatomic) NSString *openingTime;
@property (copy, nonatomic) NSString *isOpening;
@property (strong, nonatomic) StoreObject *currentStore;

@end

@implementation HFShopMapViewController

#pragma mark - Controller's Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if ([HFLocationManager sharedInstance].currentLocation) {
        [self performSelector:@selector(setMapCenterPoint)
                   withObject:nil
                   afterDelay:0.2];
        self.currentCenterLocation = [HFLocationManager sharedInstance].currentLocation;
        [self configureStores];
    }
    else
    {
        [[HFLocationManager sharedInstance] startUpdatingLocation:^{
            [self performSelector:@selector(setMapCenterPoint)
                       withObject:nil
                       afterDelay:0.2];
            self.currentCenterLocation = [HFLocationManager sharedInstance].currentLocation;
            [self configureStores];
        } failure:^(NSError *error) {
            //[HFGeneralHelpers handleLocationServiceError:error];
        }];
    }
    
    // Configure rangeView
    //
    _rangeViewSection.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, -50);
    
    _animationBottom = [[UIView alloc]initWithFrame:self.view.bounds];
    _animationBottom.alpha = 0.5f;
    _animationBottom.backgroundColor = [UIColor blackColor];
    
    // Add a pan gesture to control the range view
    //
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_animationBottom addGestureRecognizer:tapGestureRecognizer];
    
    _titleLabelDatas = @[@"全美国", @"旧金山", @"纽约"];
    
    // Setup style
    //
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    
    // Bar button
    //
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStylePlain target:self action:@selector(showList)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:255/255 green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIImage *buttonImage = [UIImage imageNamed:@"list"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    // Configure Store Info View
    //
    // 49 for tabBar height and 64 for the height of navigation bar
    //
    _storeInfoView.center = CGPointMake(self.view.size.width/2,
                                        self.view.size.height - self.storeInfoView.height/2 - 49 - 64);
    
    // Add Tap Gesture
    //
    
    UITapGestureRecognizer *storeInfoTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStoreInfoView)];
    [self.storeInfoView addGestureRecognizer:storeInfoTapGestureRecognizer];
    
}

- (void)tapStoreInfoView {
    
    HFShopDetailViewController *shopDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"shopDetail"];
    shopDetailViewController.cellInfo = self.currentStore;
    shopDetailViewController.openingTime = self.openingTime;
    shopDetailViewController.isOpening = self.isOpening;
    
    [self.navigationController pushViewController:shopDetailViewController animated:YES];
    
}

- (void)setMapCenterPoint
{
    [self.mapView setShowsUserLocation:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance ([HFLocationManager sharedInstance].currentLocation.coordinate, defaultRadius, defaultRadius);
    [self.mapView setRegion:region animated:YES];
    [self performSelector:@selector(setFirstMapMovingDone) withObject:nil afterDelay:1.5];
}

- (void)setMapCenterPointWithLongitude:(NSNumber *)longitude andLatitude:(NSNumber *)latitude
{
    if (latitude && latitude) {
        [self.mapView setShowsUserLocation:YES];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (location, defaultRadius, defaultRadius);
        [self.mapView setRegion:region animated:YES];
        [self performSelector:@selector(setFirstMapMovingDone) withObject:nil afterDelay:1.5];
    }
}

- (void)setFirstMapMovingDone
{
    self.isFirstMapMovingDone = YES;
}

-(void) configureStores
{
    self.storesArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFALLStoresPath]];
    [self configureAnnotationBy:self.titleButton.currentTitle];
    
}

- (void)configureAnnotationBy:(NSString *)storeCity {
    
    // Switch the city to fetch the different data
    //
    // code here ......
    //
    //
    
    //self.storesArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
    
    for (StoreObject *store in self.storesArray) {
        
        MapPinView *mapPinView = [[MapPinView alloc]init];
        
        CLLocationCoordinate2D pinViewCoordinate = CLLocationCoordinate2DMake(store.latitude.floatValue, store.longitude.floatValue);
        mapPinView.coordinate = pinViewCoordinate;
        mapPinView.title = store.merchant.alias;
        mapPinView.store = store;
        
        [self.mapView addAnnotation:mapPinView];
    }
    
    //
    if (self.storesArray.count>0) {
        CLLocationCoordinate2D coor2d = CLLocationCoordinate2DMake(((StoreObject *)self.storesArray[0]).latitude.floatValue, ((StoreObject *)self.storesArray[0]).longitude.floatValue);
        MKCoordinateSpan span = {0.1,0.01};
        MKCoordinateRegion region = {coor2d,span};
        
        _mapView.delegate = self;
        [_mapView setRegion:region animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure the navigation bar
    //
    self.navigationItem.hidesBackButton = YES;

    if (([[HFLocationManager sharedInstance] locationServiceStatus]) != kCLAuthorizationStatusAuthorized) {
        // Invoke sysytem alertView
        [[HFLocationManager sharedInstance] startUpdatingLocation];
    }
    NSLog(@"Tag:%i",_currentStoreCity);
    if(_currentStoreCity == 0){
        _currentStoreCity=100;
    }
    if(_currentStoreCity == 100){
        [self setMapCenterPoint];
    }else{
        [self getStoreByCity:_currentStoreCity - 100];
    }
    [self switchTitleButtonState:_currentStoreCity];
}

- (void)switchTitleButtonState:(kStoreCity)storeCity {
    
    // Change the button's color
    // RGB: 237 104 82
    //
    for (int i = 100; i < 103; i++) {
        
        UIButton *button = (UIButton *)[_titleSubButtonBottom viewWithTag:i];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        if (i == storeCity) {
            button.layer.borderColor = [UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f].CGColor;
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.titleButton setTitle:self.titleLabelDatas[i-100] forState:UIControlStateNormal];
        }
        
    }
    if (storeCity == kStoreCityAllCity) {
        [self reloadAllStores];
    }else{
        [self getStoreByCity:storeCity - 100];
    }
    _currentStoreCity = storeCity;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[HFLocationManager sharedInstance] stopUpdatingLocation];

    [_mapView deselectAnnotation:self.mapView.selectedAnnotations.lastObject animated:YES];
    
    _storeInfoView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap Gesture

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [_animationBottom removeFromSuperview];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _rangeViewSection.transform = CGAffineTransformMakeTranslation(0, -self.rangeViewSection.bounds.size.height);
                         [self.titleButton setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
                     }];
    _isRangeViewShow = NO;
    
}

- (IBAction)navigationVBarTitleTapped:(id)sender {
    
    if (! self.isRangeViewShow) {
        
        
        [self.view addSubview:self.animationBottom];
        self.animationBottom.alpha = 0.0f;
        
        [self.view bringSubviewToFront:self.rangeViewSection];
        
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.animationBottom.alpha = 0.5f;
                             
                             _rangeViewSection.transform = CGAffineTransformMakeTranslation(0, self.rangeViewSection.bounds.size.height);
                             [self.titleButton setImage:[UIImage imageNamed:@"dropup"] forState:UIControlStateNormal];
                         }];
        _isRangeViewShow = YES;
        return ;
    }
    
    [_animationBottom removeFromSuperview];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _rangeViewSection.transform = CGAffineTransformMakeTranslation(0, -self.rangeViewSection.bounds.size.height);
                         [self.titleButton setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
                     }];
    _isRangeViewShow = NO;
    
}


#pragma mark - MKAnnotation Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"PinAnnotation"];
    
    annotationView.image = [UIImage imageNamed:@"pin_blue"];
    
    NSLog(@"Annotaion title : %@", annotation.title);
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    CLLocationDistance distance = [self.currentCenterLocation distanceFromLocation:newCenter];
    // if it's not the first map zoom in animation, and the center has been moved a signification distance
    // we want to start the timer
    if (self.isFirstMapMovingDone && distance > 10000) {
        self.currentCenterLocation = newCenter;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    self.storeInfoView.hidden = NO;
    view.image = [UIImage imageNamed:@"pin_orange"];
    
    MapPinView *annotaionView = self.mapView.selectedAnnotations.lastObject;
    
    self.storeNameCN.text = annotaionView.store.merchant.merchantNameCN;
    self.storeNameEN.text = annotaionView.store.merchant.merchantName;
    self.storeLocationName.text = annotaionView.store.storeName;
 
    if (annotaionView.store.distance) {
        if ([annotaionView.store.distance intValue] <= 2) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%d 公里, 步行%i分钟",[annotaionView.store.distance intValue],[self getWalkingDurationFromDistance:annotaionView.store.distance]];
        } else{
            self.distanceLabel.text = [NSString stringWithFormat:@"%d 公里",[annotaionView.store.distance intValue]];
        }
    }else {
        self.distanceLabel.hidden = YES;
    }
    
    NSURLRequest *imageURLRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:annotaionView.store.coverPictureURL]];
    [self fetchImageWithRequest:imageURLRequest finished:^(id responseObject) {
        self.mapDetailImageView.image = [[UIImage alloc]initWithData:responseObject];
    }];
    
    // Pass the store data and push detail view
    //
    [self configureOpeningTime];
    [self configureDateStuffByStore:annotaionView.store];
    _currentStore = annotaionView.store;
    
    
}

- (NSInteger )getWalkingDurationFromDistance: (NSNumber *) distance
{
    return round([distance floatValue] / 0.080467);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    view.image = [UIImage imageNamed:@"pin_blue"];
    
}

#pragma mark - AFNetworking

- (void)fetchImageWithRequest:(NSURLRequest *)request finished:(void(^)(id responseObject))success {
    
    // Fetch image
    //
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    httpRequestOperation.responseSerializer.acceptableContentTypes = nil;
    
    [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [httpRequestOperation start];
    
}

#pragma mark - Show Shop List View Controller

- (void)showList {
    
    // Show the HFShopListViewController with a flip animation
    //
    [UIView beginAnimations:@"animation" context:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:HFSWITCHCITYDATA
                                                       object:nil
                                                     userInfo:@{@"currentStoreCity":@(self.currentStoreCity)}];
    
}
- (IBAction)locateUser:(id)sender {
    
    [self setMapCenterPoint];
}

- (IBAction)switchCityTapped:(id)sender {
    UIButton *currentButton = (UIButton *)sender;
    UIView *buttonSuperView =currentButton.superview;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         _rangeViewSection.transform = CGAffineTransformMakeTranslation(0, -self.rangeViewSection.bounds.size.height);
                         self.animationBottom.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished) {
                         [self.titleButton setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
                         [_animationBottom removeFromSuperview];
                         
                     }];
    _isRangeViewShow = NO;
    
    // Change the button's color
    // RGB: 237 104 82
    //
    for (int i = 100; i < 103; i++) {
        
        UIButton *button = (UIButton *)[buttonSuperView viewWithTag:i];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        if (i == currentButton.tag) {
            button.layer.borderColor = [UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f].CGColor;
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.titleButton setTitle:self.titleLabelDatas[i-100] forState:UIControlStateNormal];
            _currentStoreCity = currentButton.tag;
        }
        
    }
    NSLog(@"Tag:%i",currentButton.tag);
    if (currentButton.tag == 100) {
        [self reloadAllStores];
    }else{
        [self getStoreByCity:currentButton.tag-100];
    }
    self.storeInfoView.hidden = YES;
}

#pragma mark - API Calls

- (void)getStoreByCity:(int)cityId {
    
    // The city button's tag is from 100 ~ 104
    //
    // Switch the date source
    //
    [SVProgressHUD show];
    [HFStoreServerApi getStoresForCity:cityId
                                forLocation:[HFLocationManager sharedInstance].currentLocation
                            pageNumber:1
                         couponPerPage:10
                               success:^(id stores) {
                                   [SVProgressHUD dismiss];
                                   [self.storesArray removeAllObjects];
                                   [self setStoresArrayForMap:stores WithCityId:cityId];
                                  
                                   NSLog(@"City %i stores loaded.",cityId);
                               } failure:^(NSError *error) {
                                   NSLog(@"%@", error);
                                   [SVProgressHUD dismiss];
                                   if (error.code == 9999) {
                                       //this is when internet is not reachable, we check if there is any downloaded coupon
                                   }
                               }];
}

- (void)reloadAllStores {
    
    // The city button's tag is from 100 ~ 104
    //
    // Switch the date source
    //
    [SVProgressHUD show];
    [HFStoreServerApi getStoresForLocation:[HFLocationManager sharedInstance].currentLocation
                                pageNumber:1
                             couponPerPage:10
                                   success:^(id stores) {
                                       [self.storesArray removeAllObjects];
                                       [self setStoresArrayForMap:stores WithCityId:0];
                                       NSLog(@"All stores loaded.");
                                   } failure:^(NSError *error) {
                                       NSLog(@"%@", error);
                                       [SVProgressHUD dismiss];
                                       if (error.code == 9999) {
                                           //this is when internet is not reachable, we check if there is any downloaded coupon
                                       }
                                   }];
}

- (void) setStoresArrayForMap:(NSDictionary *) stores WithCityId:(int) cityId{
    for (NSDictionary *dict in stores) {
        NSDictionary *storeInfo =dict[@"storeInfo"];
        
        StoreObject *store = [[StoreObject alloc] initWithDictionary:storeInfo];
        if (dict[@"coupons"]) {
            NSArray *coupons =dict[@"coupons"];
            if(coupons&&[coupons isKindOfClass:[NSArray class]]&&coupons.count>0){
                store.coupons = [[NSMutableArray alloc]init];
                for (NSDictionary *couponDict in coupons) {
                    CouponObject *coupon = [[CouponObject alloc] initWithDictionary:couponDict];
                    [store.coupons addObject:coupon];
                }
            }
        }
        
        if(storeInfo[@"categories"]&&[storeInfo[@"categories"] isKindOfClass:[NSArray class]]){
            store.categories = [[NSMutableArray alloc]init];
            for (NSDictionary *categoryDict in storeInfo[@"categories"]) {
                HFCategory *category = [[HFCategory alloc] initWithDictionary:categoryDict];
                [store.categories addObject:category];
            }
        }
        
        if(storeInfo[@"storePictureURLs"]&&[storeInfo[@"storePictureURLs"] isKindOfClass:[NSArray class]]){
            store.storePictureURLs = [[NSMutableArray alloc]initWithArray:storeInfo[@"storePictureURLs"]];
        }
        
        if(storeInfo[@"brands"]&&[storeInfo[@"brands"] isKindOfClass:[NSArray class]]){
            store.brands = [[NSMutableArray alloc]init];
            for (NSDictionary *brandDict in storeInfo[@"brands"]) {
                HFBrand *brand = [[HFBrand alloc] initWithDictionary:brandDict];
                [store.brands addObject:brand];
            }
        }
        
        // Long distance
        if (![HFLocationManager sharedInstance].currentLocation) {
            store.distance = nil;
            static dispatch_once_t pred;
            dispatch_once(&pred, ^{
                [[HFLocationManager sharedInstance] startUpdatingLocation];
            });
        } else {
            double distance = [HFGeneralHelpers distanceInKMFromLocation:[HFLocationManager sharedInstance].currentLocation toLocation:[[CLLocation alloc] initWithLatitude:store.latitude.floatValue longitude:store.longitude.floatValue]];
            store.distance = [NSNumber numberWithDouble:distance];
        }
        [self.storesArray addObject:store];
    }
    
    [HFGeneralHelpers saveData:self.storesArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFALLStoresPath]];
    
    if(cityId == 0){
        [self setMapCenterPoint];
    }else{
        [self configureStores];
        StoreObject *lastStore = [self.storesArray lastObject];
        [self setMapCenterPointWithLongitude:lastStore.longitude andLatitude:lastStore.latitude];
        
    }
    [SVProgressHUD dismiss];
}

- (void)configureOpeningTime {
    
    // Fetch the current date
    //
    NSDate *date = [NSDate date];
    NSString *dateFormatString = [NSDateFormatter dateFormatFromTemplate:@"E" options:0
                                                                  locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatString];
    
    NSString *todayString = [dateFormatter stringFromDate:date];
    
    // Fetch the current time
    //
    NSDate *time = [NSDate date];
    NSDateFormatter *timeFormater = [[NSDateFormatter alloc]init];
    [timeFormater setDateFormat:@"k:mm"];
    NSString *currentTime = [timeFormater stringFromDate:time];
    
    // Store current time into array
    //
    NSArray *currentTimeArray = [currentTime componentsSeparatedByString:@":"];
    NSInteger currentHour = ((NSString *)currentTimeArray[0]).integerValue;
    NSInteger currentMinute = ((NSString *)currentTimeArray[1]).integerValue;
    
    // Fetch open and close time
    //
    NSString *openTimes = self.openingTimes[todayString][0];
    NSString *closeTimes = self.openingTimes[todayString][1];
    
    // Fetch hours and minites
    //
    NSInteger openHour = ((NSString *)openTimes).integerValue/100;
    NSInteger openMinute = ((NSString *)openTimes).integerValue%100;
    NSInteger closeHour = ((NSString *)closeTimes).integerValue/100;
    NSInteger closeMinute = ((NSString *)closeTimes).integerValue%100;
    
    if ((openHour * 60 + openMinute) <= (currentHour * 60 + currentMinute) &&
        (currentHour * 60 + currentMinute) <= (closeHour * 60 + closeMinute)) {
        self.isOpening = @"营业中";
    }
    
    
    // Configure Opeing time
    //
    self.openingTime = [NSString stringWithFormat:@"早%@%@到晚%@%@营业",
                             [self convertOpenTime:openHour],
                             openMinute == 0? @"":[NSString stringWithFormat:@":%i", openMinute],
                             [self convertOpenTime:closeHour],
                             closeMinute == 0? @"": [NSString stringWithFormat:@":%i", closeMinute]
                             ];
    
}

- (NSString *)convertOpenTime:(NSInteger )originString {
    
    return [NSString stringWithFormat:@"%i", originString%12];
}

- (void)configureDateStuffByStore:(StoreObject *)store {
    
    // Store the date into the dictionary
    //
    if (! _openingTimes) {
        _openingTimes = [[NSMutableDictionary alloc]init];
    }
    
    if (_openingTimes.count > 0) {
        [_openingTimes removeAllObjects];
    }
    
    [_openingTimes setValue:@[store.storeHour.mondayOpenHour ? : @"",
                              store.storeHour.mondayCloseHour ? : @""]
                     forKey:@"Mon"];
    [_openingTimes setValue:@[store.storeHour.tuesdayOpenHour ? : @"",
                              store.storeHour.tuesdayCloseHour ? : @""]
                     forKey:@"Tue"];
    [_openingTimes setValue:@[store.storeHour.wednesdayOpenHour ? : @"",
                              store.storeHour.wednesdayCloseHour ? : @""]
                     forKey:@"Wed"];
    [_openingTimes setValue:@[store.storeHour.thrusdayOpenHour ? : @"",
                              store.storeHour.thrusdayCloseHour ? : @""]
                     forKey:@"Thu"];
    [_openingTimes setValue:@[store.storeHour.fridayOpenHour ? : @"",
                              store.storeHour.fridayCloseHour ? : @""]
                     forKey:@"Fri"];
    [_openingTimes setValue:@[store.storeHour.saturdayOpenHour ? : @"",
                              store.storeHour.saturdayCloseHour ? : @""]
                     forKey:@"Sat"];
    [_openingTimes setValue:@[store.storeHour.sundayOpenHour ? : @"",
                              store.storeHour.sundayCloseHour ? : @""]
                     forKey:@"Sun"];
}


@end
