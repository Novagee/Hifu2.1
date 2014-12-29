//
//  HFitemListViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/7/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFShopListViewController.h"
#import "HFRangeViewController.h"
#import "HFShopMapViewController.h"
#import "HFShopListTableViewCell.h"
#import "HFShopDetailViewController.h"
#import "StoreObject.h"
#import "CouponObject.h"
#import "HFWifiViewController.h"
#import "HFHotTeaViewController.h"
#import "HFChineseHelpViewController.h"
#import "HFLocationManager.h"
#import "HFStoreServerApi.h"
#import "HFUserApi.h"
#import "HFCategory.h"
#import "HFBrand.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import <POP/POP.h>
#import "DCNetworkReactor.h"
#import "HFGeneralHelpers.h"
#import "UserServerApi.h"
#import "SVProgressHUD.h"
#import <Appsee/Appsee.h>
#import "UserServerApi.h"
#import "HFUIHelpers.h"

@interface HFShopListViewController ()<UISearchBarDelegate, HFShopListCellDelegate>{
    NSMutableArray *storesArray;
    BOOL hasMoreToLoad, shouldFilp;
    int currentPageNumber;
    CGPoint allCouponContentOffset, favoriteCouponContentOffset;
    id getStoreRequest;
}

@property (weak, nonatomic) IBOutlet UIScrollView *bottomView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *searchBarBottomView;
@property (strong, nonatomic) HFShopMapViewController *mapViewController;
@property (assign, nonatomic) BOOL isRangeViewShow;
@property (weak, nonatomic) IBOutlet UIView *rangeViewSection;
@property (weak, nonatomic) IBOutlet UIView *titleSubButtonBottom;
@property (strong, nonatomic) UIView *animationBottom;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic, weak) IBOutlet UIView *loadingMoreView;
@property (nonatomic, weak) IBOutlet UIImageView *loadingMoreImageView;
@property (strong, nonatomic) NSArray *storeCity;
@property (strong, nonatomic) NSArray *storeDistrict;

@property (assign, nonatomic) BOOL mapServiceDisable;

// Use this array to store the navigation bar's titles
//
@property (strong, nonatomic) NSArray *titleLabelDatas;

@end

@implementation HFShopListViewController

#pragma mark - Controller's Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerCustomCellsFromNibs];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    
#warning We should use autolayout later
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50);
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
    
    // Configure API
    //
    storesArray = [NSMutableArray new];
    [self setupLoadingMoreView];
    
    // Init the "mapViewController" only one time
    //
    _mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"shopMap"];

    // Configure store by city
    //
    self.storeCity = @[@100,@102,@101];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavorite:) name:HFAddStoreToFavorite object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavorite:) name:HFRemoveStoreToFavorite object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swithCityData:) name:HFSWITCHCITYDATA object:nil];
    
    _titleLabelDatas = @[@"全美国", @"旧金山", @"纽约"];
    
    [self setTitleForFirstLunch];
    
}

- (void)setTitleForFirstLunch
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"appFirstLaunch"]) {
        
        [_titleButton setTitle:self.titleLabelDatas.firstObject forState:UIControlStateNormal];
        _currentStoreCity = kStoreCityAllCity;
    }
}

- (void)reloadFavorite:(NSNotification *)notification{

    [self.tableView reloadData];
    
}

- (void)swithCityData:(NSNotification *)notification {
    
    NSDictionary *useInfo = notification.userInfo;
    int cityId = ((NSNumber *)useInfo[@"currentStoreCity"]).intValue;
    _currentStoreCity = cityId;
//    [self switchTitleButtonState:cityId];
   
    // Change the button's color
    // RGB: 237 104 82
    //
    for (int i = 100; i < 103; i++) {
        
        UIButton *button = (UIButton *)[_titleSubButtonBottom viewWithTag:i];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        if (i == cityId) {
            button.layer.borderColor = [UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f].CGColor;
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:104/255.0f blue:82/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.titleButton setTitle:self.titleLabelDatas[i-100] forState:UIControlStateNormal];
        }
        
    }
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setupPullToRefresh];
    
    if(_currentStoreCity == 0){
        _currentStoreCity = 100;
    }
    NSLog(@"Current Store : %i", self.currentStoreCity);
    
    if (![HFLocationManager sharedInstance].currentLocation) {
        
        [Appsee addEvent:@"User Location Shared" withProperties:@{@"userId":[UserServerApi sharedInstance].currentUserId}];
        // Invoke sysytem alertView
        [[HFLocationManager sharedInstance] startUpdatingLocation:^{
            currentPageNumber = 0;
            
            if (_currentStoreCity && _currentStoreCity != kStoreCityAllCity) {
                [self getStoreByCity:_currentStoreCity - 100];
            } else {
                [self getStores];
            }
            
        } failure:^(NSError *error) {
            
            [HFGeneralHelpers handleLocationServiceError:error];
            
            _mapServiceDisable = YES;
            
            [self reloadAllStores];
        }];
    } else {
        [Appsee addEvent:@"User Location NOT Shared" withProperties:@{@"userId":[UserServerApi sharedInstance].currentUserId}];
        if (_currentStoreCity && _currentStoreCity != kStoreCityAllCity) {
            
            [self getStoreByCity:_currentStoreCity - 100];
        } else {
            [self getStores];
        }
    }

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
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

-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HFShopListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HFShopListTableViewCell"];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return [storesArray count];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 348.0f;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HFShopListTableViewCell *cell = (HFShopListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"HFShopListTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSLog(@"Cell delegate : %@", cell.delegate);
    StoreObject *store = [storesArray objectAtIndex:indexPath.row];
    NSLog(@"Store id: %@",store.storeId);
    cell.store = store;
    [cell constructCellBasedOnCoupon:cell.store];
    return cell;
    
}

#pragma mark - UISearch Bar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    // Add search code here
    // ......
    
    return YES;
}

#pragma mark - UI Control's Action

- (IBAction)showMapView:(id)sender {
    [Appsee addEvent:@"Show Map View Button Clicked"];
    [UIView beginAnimations:@"animation" context:nil];
    
    self.mapViewController.view.alpha = 1.0f;
    [self.mapViewController.titleButton setTitle:self.titleButton.currentTitle forState:UIControlStateNormal];
    self.mapViewController.currentStoreCity = self.currentStoreCity;
    
    [self.navigationController pushViewController:self.mapViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFShopDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"shopDetail"];
    
    detailViewController.cellInfo = storesArray[indexPath.row];
    
    // Fetch the cell and pass the store opening time stuff
    //
    HFShopListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HFShopListTableViewCell" forIndexPath:indexPath];
    StoreObject *store = [storesArray objectAtIndex:indexPath.row];
    cell.store = store;
    [cell constructCellBasedOnCoupon:cell.store];
    
    detailViewController.openingTime = cell.openingTime.text;
    detailViewController.isOpening = cell.isOpeningLabel.text;

    //app see stuff
    [Appsee addEvent:@"Store Detail Clicked" withProperties:@{@"storeId":store.storeId}];
    
    [self.navigationController pushViewController:detailViewController animated:YES];

}

#pragma mark - Test Cell Delegate

- (void)handleShopListLikeButton:(UIButton *)likeButton {
    
    NSLog(@"Tapped like button");
    
    if(![UserServerApi sharedInstance].currentUserId){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:@"请登录您的个人账户" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIView *view = likeButton;
    
    while (! [view isKindOfClass:[HFShopListTableViewCell class]]) {
        view = view.superview;
    }

    HFShopListTableViewCell *shopListTableViewCell = (HFShopListTableViewCell *)view;
    
    if (shopListTableViewCell.liked) {
        [likeButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        shopListTableViewCell.liked = !shopListTableViewCell.liked;
        
        [self unfavoriteStoreId:shopListTableViewCell.store];
        return ;
    }
    [likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self favoriteStoreId:shopListTableViewCell.store];
    
    [self favouriteAnimationWithButton:likeButton];
    
    shopListTableViewCell.liked = !shopListTableViewCell.liked;
    return;
}

#pragma mark - Like Animations

- (void)favouriteAnimationWithButton:(UIButton *)likeButton {
    
    // Convert the like button's center to window
    //
    UIView *view = likeButton;
    while (! [view isKindOfClass:[HFShopListTableViewCell class]]) {
        view = view.superview;
    }
    HFShopListTableViewCell *shopListTableViewCell = (HFShopListTableViewCell *)view;
    
    CGPoint likeButtonCenter = [shopListTableViewCell convertPoint:likeButton.center toView:self.view.window];
    
    // Duplicate a fake like button for animation
    //
    UIView *fakeLikeButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like"]];
    fakeLikeButton.center = likeButtonCenter;
    
    [self.view.window addSubview:fakeLikeButton];
    
    // Fetch the tab Bar Item
    //
    CGPoint finalPoint = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, [UIScreen mainScreen].bounds.size.height - 30);
    
    // Configure the like animation
    //
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:likeButtonCenter];
    [path addLineToPoint:likeButtonCenter];
    [path addLineToPoint:[self makeTopPoint:likeButtonCenter]];
    [path addLineToPoint:finalPoint];
    [path addLineToPoint:finalPoint];
    pathAnimation.path = path.CGPath;
    
    pathAnimation.keyTimes = @[@(0), @(0.2), @(0.5), @(0.9), @(1)];
    pathAnimation.duration = 0.7f;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)]
                              ];
    scaleAnimation.keyTimes =  @[@(0), @(0.3), @(0.5), @(0.7), @(1)];
    
    scaleAnimation.duration = 0.7f;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[pathAnimation, scaleAnimation];
    animationGroup.duration = 0.7f;
    
    [fakeLikeButton.layer addAnimation:animationGroup forKey:@""];
    
    // Remove the fake like button once the animation stop
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fakeLikeButton removeFromSuperview];
    });
    
}

- (CGPoint)makeTopPoint:(CGPoint)startPoint {
    
    return CGPointMake(startPoint.x - 30, startPoint.y - 30);
    
}

#pragma mark - Navigation Title Button

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

#pragma mark - Range View Actions

- (IBAction)switchCityTapped:(id)sender {
    UIButton *currentButton = (UIButton *)sender;
    [Appsee addEvent:@"Shop List Location Switched " withProperties:@{@"cityId":[NSString stringWithFormat:@"%i",currentButton.tag-100]}];
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
    
    // Handle the communication to the map view
    //
    [self switchTitleButtonState:currentButton.tag];
    
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
    _currentStoreCity = storeCity;
     NSLog(@"Tag:%i",storeCity);
    if (storeCity == kStoreCityAllCity) {
        [self reloadAllStores];
    }else{
        [self getStoreByCity:storeCity - 100];
    }
    
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
                                pageNumber:1//currentPageNumber
                             couponPerPage:200
                                   success:^(id stores) {
                                       [SVProgressHUD dismiss];
//                                       if (currentPageNumber == 0) {
                                           [storesArray removeAllObjects];
//                                       }
                                       [self setStoresArrayForList:stores];
                                       hasMoreToLoad = ([storesArray count] == 10);
                                       [self hideLoadMore];
                                       [self.tableView stopRefreshAnimation];
                                       [self.tableView reloadData];
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
    
    NSLog(@"Reload all store");
    
    // The city button's tag is from 100 ~ 104
    //
    // Switch the date source
    //
    [SVProgressHUD show];
    [HFStoreServerApi getStoresForLocation:[HFLocationManager sharedInstance].currentLocation
                                pageNumber:1
                             couponPerPage:200
                                   success:^(id stores) {
//                                       if (currentPageNumber == 0) {
                                           [storesArray removeAllObjects];
//                                       }
                                       [self setStoresArrayForList:stores];
                                       
                                       hasMoreToLoad = ([storesArray count] == 10);
                                       [self hideLoadMore];
                                       [self.tableView stopRefreshAnimation];
                                       [SVProgressHUD dismiss];
                                       
                                        NSLog(@"All stores loaded.");
                                       [self.tableView reloadData];
                                   } failure:^(NSError *error) {
                                       NSLog(@"Get Store Error : %@", error);
                                       [SVProgressHUD dismiss];
                                       if (error.code == 9999) {
                                           //this is when internet is not reachable, we check if there is any downloaded coupon
                                       }
                                   }];
}

- (void)getStores {
//    currentPageNumber ++;
    getStoreRequest = [HFStoreServerApi getStoresForLocation:[HFLocationManager sharedInstance].currentLocation
                                                       pageNumber:1//currentPageNumber
                                                    couponPerPage:200
                                                          success:^(id stores) {
//                                                              if (currentPageNumber == 0) {
                                                                  [storesArray removeAllObjects];
//                                                              }

                                                              [self setStoresArrayForList:stores];
                                                              hasMoreToLoad = ([storesArray count] == 10);
                                                              [self hideLoadMore];
                                                              [self.tableView stopRefreshAnimation];

                                                              [self.tableView reloadData];
                                                          } failure:^(NSError *error) {
                                                              NSLog(@"%@", error);
                                                              
                                                              if (error.code == 9999) {
                                                                  //this is when internet is not reachable, we check if there is any downloaded coupon
                                                              }
                                                          }];

}

- (void) setStoresArrayForList:(NSDictionary *) stores{
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
        
        if(storeInfo[@"categoryCN"]&&[storeInfo[@"categoryCN"] isKindOfClass:[NSString class]]){
            store.categories = [[NSMutableArray alloc]init];
            NSString *cates = storeInfo[@"categoryCN"];
            NSArray *strArr = [cates componentsSeparatedByString:@"，"];
            for (NSString *category in strArr) {
                [store.categories addObject:category];
            }
        }
    
        if(storeInfo[@"storePictureURLs"]&&[storeInfo[@"storePictureURLs"]  isKindOfClass:[NSArray class]]){
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
        if (![HFLocationManager sharedInstance].currentLocation && !self.mapServiceDisable) {
            store.distance = nil;
            static dispatch_once_t pred;
            dispatch_once(&pred, ^{
                [[HFLocationManager sharedInstance] startUpdatingLocation];
            });
        } else {
            double distance = [HFGeneralHelpers distanceInKMFromLocation:[HFLocationManager sharedInstance].currentLocation toLocation:[[CLLocation alloc] initWithLatitude:store.latitude.floatValue longitude:store.longitude.floatValue]];
            store.distance = [NSNumber numberWithDouble:distance];
        }
        [storesArray addObject:store];
    }
    [HFGeneralHelpers saveData:storesArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFALLStoresPath]];
    
}

- (void)hideLoadMore {
    self.loadingMoreView.hidden = YES;
    [self.loadingMoreImageView stopAnimating];
}

-(void)setupPullToRefresh {
    NSLog(@"Setup pull refresh");
    
    [self.tableView addPullToRefreshActionHandler:^{
        currentPageNumber = 0;
        shouldFilp = NO;
        [getStoreRequest cancel];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(getStores)
                                       userInfo:nil
                                        repeats:NO];
    }
                                 ProgressImagesGifName:@"loadingA.gif"
                                  LoadingImagesGifName:@"loadingA.gif"
                               ProgressScrollThreshold:40
                                 LoadingImageFrameRate:60];
}

- (void)setupLoadingMoreView {
    self.loadingMoreView.hidden = YES;
    
    self.loadingMoreImageView.layer.zPosition = MAXFLOAT;
    self.loadingMoreImageView.animationDuration = 1.4;
    self.loadingMoreImageView.animationRepeatCount = MAXFLOAT;
    
    NSMutableArray *animationImages = [NSMutableArray new];
    for (int i = 0 ; i < 11; i++) {
        [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"couponLoadMore_%d",i]]];
    }
    
    self.loadingMoreImageView.animationImages = animationImages;
}

- (void)favoriteStoreId:(StoreObject *)store
{
    //call api
    [HFUserApi favoriteStoreId:store.storeId
                                 withUserId:[UserServerApi sharedInstance].currentUserId//@5
                                    success:^{
                                        NSLog(@"Favorite Store Success");
                                        //save to local
                                        NSMutableArray* storeArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                                        if (!storeArray) {
                                            storeArray = [NSMutableArray new];
                                        }
                                        [storeArray addObject:store];
                                        [HFGeneralHelpers saveData:storeArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                                        NSLog(@"Store Saved To Local");
                                    } failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                    }];
}

- (void)unfavoriteStoreId:(StoreObject *)store
{
//call api
    [HFUserApi unfavoriteStoreId:store.storeId
                                   withUserId:[UserServerApi sharedInstance].currentUserId//@5
                                      success:^{
                                          NSLog(@"Unfavorite Store Success");
                                          //remove from local
                                          NSMutableArray* storeArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                                          for (StoreObject *storeObj in storeArray) {
                                              if (storeObj&&storeObj.storeId&&storeObj.storeId == store.storeId) {
                                                  [storeArray removeObject:storeObj];
                                                  break;
                                              }
                                          }
                                          [HFGeneralHelpers saveData:storeArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                                          NSLog(@"Store Removed From Local");
                                      } failure:^(NSError *error) {
                                          NSLog(@"%@", error);
                                      }];

    
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    HFShopMapViewController *shopMapViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"pushMap"]) {
        
        
        
    }
    
}

@end
