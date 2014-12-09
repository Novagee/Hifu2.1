//
//  HFShopDetailViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFShopDetailViewController.h"

#import "HFWifiViewController.h"
#import "HFHotTeaViewController.h"
#import "HFChineseHelpViewController.h"
#import "HFDiscountViewController.h"
#import "HFStoreInfoDetailViewController.h"
#import "HFStoreIntroductionViewController.h"

#import "JCRBlurView.h"
#import "HFCategory.h"
#import "MerchantObject.h"
#import "MapPinView.h"

#import <AFNetworking/AFNetworking.h>
#import "StoreObject.h"
#import "CouponObject.h"
#import "HFUserApi.h"

#import "HFCouponDisctountView.h"
#import "HFCouponGiftView.h"
#import "UserServerApi.h"
#import <Appsee/Appsee.h>
#import "MerchantObject.h"
#import "HFGeneralHelpers.h"
#import "HFUIHelpers.h"
#import "UIView+EasyFrames.h"

#import "HFLocationManager.h"
#import "SVProgressHUD.h"

@interface HFShopDetailViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, HFCouponDisctountViewDelegate, HFCouponGiftViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainBottomView;
;
@property (strong, nonatomic) UIImage *rightButtonImage;

#pragma mark - Goods Scroll View Section Property

@property (weak, nonatomic) IBOutlet UIView *goodsBottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *goodsScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *goodsPageControl;
@property (assign, nonatomic) BOOL animationStop;

#pragma mark - Store Basic Info Property

@property (weak, nonatomic) IBOutlet UIView *storeBasicInfoViewSection;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeOpenHour;
@property (weak, nonatomic) IBOutlet UILabel *storeOpeningLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeGoodsTypeFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeGoodsTypeSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeGoodsTypeThirdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeGoodsTypeFirstDot;
@property (weak, nonatomic) IBOutlet UIImageView *storeGoodsTypeSecondDot;

@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIImageView *giftButtonImage;
@property (weak, nonatomic) IBOutlet UIButton *discountButton;
@property (weak, nonatomic) IBOutlet UIImageView *discountButtonImage;

#pragma mark - Store Service View Section

@property (weak, nonatomic) IBOutlet UIView *storeServiceViewSection;
@property (weak, nonatomic) IBOutlet UIButton *wifiButton;
@property (weak, nonatomic) IBOutlet UIButton *chineseButton;
@property (weak, nonatomic) IBOutlet UIButton *hotTeaButton;

#pragma mark - Shop Introduce View Section Property

@property (weak, nonatomic) IBOutlet UIView *storeIntroduceViewSection;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *storeIntroduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *readAllButton;
@property (weak, nonatomic) IBOutlet UILabel *detailDotsLabel;
@property (weak, nonatomic) IBOutlet UIView *introductionTextBottom;

#pragma mark - Store Location Info View Section Property

@property (weak, nonatomic) IBOutlet UILabel *storeAddress;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressCN;
@property (weak, nonatomic) IBOutlet UILabel *storeDistanceAndTime;

#pragma mark - Store Opening Time View Section Property

@property (weak, nonatomic) IBOutlet UILabel *mondayTime;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayTime;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayTime;
@property (weak, nonatomic) IBOutlet UILabel *thursdayTime;
@property (weak, nonatomic) IBOutlet UILabel *fridayTime;
@property (weak, nonatomic) IBOutlet UILabel *saturdayTime;
@property (weak, nonatomic) IBOutlet UILabel *sundayTime;

#pragma mark - Store Coupon Section View

@property (weak, nonatomic) IBOutlet UIView *couponHeader;
@property (assign, nonatomic) CGPoint smartOffset;
@property (strong, nonatomic) NSMutableArray *couponViews;

#pragma mark - Store Location View Section

@property (weak, nonatomic) IBOutlet UIView *locationSectionView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) CLLocationCoordinate2D currentLocation;

#pragma mark - Navigation Items

@property (strong, nonatomic) UIBarButtonItem *rightItem;

#pragma mark - Like Button Preoperty

@property (assign, nonatomic) BOOL isliked;
@property (strong, nonatomic) UIImageView *fakeLikeButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceDurationLabel;

@property (strong, nonatomic) MKMapItem *currecntMapItem;
@property (strong, nonatomic) MKMapItem *destinationMapItem;

@end

@implementation HFShopDetailViewController

#pragma mark - Controller's Life Circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Navigation items
    //
    // Configure title
    //
    self.navigationItem.title = self.cellInfo.merchant.merchantName;
    
    // Left item
    //
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // right item
    //
    UIImage *buttonImage = [UIImage imageNamed:@"detail_unlike"];
    
    //Configure like
    NSMutableArray* storeArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
    NSLog(@"LikedStoreCount:%i",storeArray.count);
    for (StoreObject *storeObj in storeArray) {
        if (storeObj&&storeObj.storeId&&storeObj.storeId == self.cellInfo.storeId) {
            self.isliked = YES;
        }
    }
    if (self.isliked) {
        buttonImage = [UIImage imageNamed:@"detail_like"];
    }
    else{
        buttonImage = [UIImage imageNamed:@"detail_unlike"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    // Configure the main scroll view
    //
    _mainBottomView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 50);
    _mainBottomView.contentSize = CGSizeMake(self.mainBottomView.bounds.size.width, 1300);
    
    // Configure User Location
    //
    self.mapView.showsUserLocation = YES;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance ([HFLocationManager sharedInstance].currentLocation.coordinate, 100000, 100000);
    [self.mapView setRegion:region animated:YES];
    _mapView.delegate = self;
    
    // Add annotation
    //
    MapPinView *storeAnnotation = [[MapPinView alloc]init];
    
    CLLocationCoordinate2D orangePinViewCoordinate3 = {self.cellInfo.latitude.floatValue, self.cellInfo.longitude.floatValue};
    
    storeAnnotation.coordinate = orangePinViewCoordinate3;
    storeAnnotation.title = ((MerchantObject *)self.cellInfo.merchant).alias;
    [self.mapView addAnnotation:storeAnnotation];
    
    // Configure like button
    //
    _fakeLikeButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_like"]];
    _fakeLikeButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 26.0f, 35.0f);
    _fakeLikeButton.hidden = YES;

    // Configure smartOffset for the coupon dynamic offset
    //
    _smartOffset = CGPointMake(self.couponHeader.centerX,
                               self.couponHeader.bounds.size.height/2 + self.couponHeader.centerY);
    // Use an array to hold the coupon views
    //
    _couponViews = [[NSMutableArray alloc]init];
    
    // Fetch the map items
    //
    [self constructMapItems];
    
    NSLog(@"Store Object Info : %@", self.cellInfo);
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // The fake button has already hidden
    //
    [self.view.window addSubview:self.fakeLikeButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self configureStoreScrollSection];
    [self configureStoreBasicInfoSection];
    [self configureStoreIntroduceSection];
    [self configureStoreLocationInfoSection];
    [self configureStoreOpeningSection];
    [self configureDistanceAndDuration];
    [self configureServerSection];
    [self configureCoupon];
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    _animationStop = YES;

    [self removeCoupons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure Goods Section View

- (void)configureStoreScrollSection {
    
    _goodsPageControl.numberOfPages = self.cellInfo.storePictureURLs.count;
    
    // Start Image Request here .....
    //
    for (int i = 0; i < self.cellInfo.storePictureURLs.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.goodsScrollView.bounds];
        imageView.center = CGPointMake(self.goodsScrollView.bounds.size.width * (i + 0.5f), self.goodsScrollView.bounds.size.height/2);
        
        // Fetch image
        //
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.cellInfo.storePictureURLs[i]]];
        [self fetchImageWithRequest:request finished:^(id responseObject) {
            
            imageView.image = [[UIImage alloc]initWithData:responseObject];
            
        }];
        
        [self.goodsScrollView addSubview:imageView];
    }
    
    _goodsScrollView.contentSize = CGSizeMake(self.goodsScrollView.bounds.size.width * self.cellInfo.storePictureURLs.count, self.goodsScrollView.bounds.size.height);
    
    [self.goodsBottomView bringSubviewToFront:self.goodsPageControl];

    _animationStop = NO;
    
    [self goodsForwardScrollTo:1];
    
}

- (void)configureStoreBasicInfoSection {
 
    _storeName.text = self.cellInfo.storeName;
    
    if (self.cellInfo.hasGift) {
        _giftButton.hidden = NO;
        _giftButtonImage.hidden = NO;
        
    }
    
    if (self.cellInfo.hasDiscount) {
        _discountButton.hidden = NO;
        _discountButtonImage.hidden = NO;
    }
    
    self.storeOpenHour.text = self.openingTime;
    self.storeOpeningLabel.text = self.isOpening;
    
    [self configureGoodsType:self.cellInfo.categories];
    
}

- (void)configureGoodsType:(NSMutableArray *)goodsTypeInfo {
    
    switch (goodsTypeInfo.count) {
            
        case 0:
            return ;
            break;
        case 1:
            
            _storeGoodsTypeFirstLabel.hidden = NO;
            _storeGoodsTypeFirstLabel.text = goodsTypeInfo[0];
            
            break;
        case 2:
            
            _storeGoodsTypeFirstLabel.hidden = NO;
            _storeGoodsTypeFirstLabel.text = goodsTypeInfo[0];
            
            _storeGoodsTypeFirstDot.hidden = NO;
            _storeGoodsTypeSecondLabel.hidden = NO;
            _storeGoodsTypeSecondLabel.text = goodsTypeInfo[1];
            
            break;
        case 3:
            
            _storeGoodsTypeFirstLabel.hidden = NO;
            _storeGoodsTypeFirstLabel.text = goodsTypeInfo[0];
            
            _storeGoodsTypeFirstDot.hidden = NO;
            _storeGoodsTypeSecondLabel.hidden = NO;
            _storeGoodsTypeSecondLabel.text = goodsTypeInfo[1];
            
            _storeGoodsTypeSecondDot.hidden = NO;
            _storeGoodsTypeThirdLabel.hidden = NO;
            _storeGoodsTypeThirdLabel.text = goodsTypeInfo[2];
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Configure Dynamic Introduction View

- (void)configureReadMore {
    
    // Dynamic label height
    //
    NSString *storeIntroductionText = self.storeIntroduceLabel.text;
    CGSize maximumLabelSize = CGSizeMake(280, 39);
    CGSize expectLabelSize = [storeIntroductionText sizeWithFont:self.storeIntroduceLabel.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect finalRect = self.storeIntroduceLabel.frame;
    
    if (expectLabelSize.height > 39) {
        finalRect.size.height = 39;
    }
    else {
        finalRect.size.height = expectLabelSize.height;
    }
    
    _storeIntroduceLabel.frame = finalRect;
        
    _readAllButton.frame = CGRectMake(self.readAllButton.origin.x,
                                      self.storeIntroduceLabel.origin.y + self.storeIntroduceLabel.height - self.readAllButton.height,
                                      self.readAllButton.width,
                                      self.readAllButton.height);
    
    _detailDotsLabel.frame = CGRectMake(self.detailDotsLabel.origin.x,
                                        self.storeIntroduceLabel.origin.y + self.storeIntroduceLabel.height - self.detailDotsLabel.height,
                                        self.detailDotsLabel.width,
                                        self.detailDotsLabel.height);
    
}

#pragma mark - Configure Dynamic Coupon View

- (void)configureCoupon {

    for (int i = 0 ; i < self.cellInfo.coupons.count; i++) {
        [self configureCouponCell:((CouponObject *)self.cellInfo.coupons[i]) withIndex:i];
    }
    
    if(!self.cellInfo.coupons||self.cellInfo.coupons.count==0){
        self.couponHeader.hidden = YES;
        self.smartOffset = CGPointMake(self.smartOffset.x, self.smartOffset.y - self.couponHeader.frame.size.height - 10 - 5);
    }
    
    // Update the location view
    //
    _locationSectionView.center = CGPointMake(self.locationSectionView.centerX,
                                              self.locationSectionView.centerY + self.smartOffset.y - self.couponHeader.centerY - self.couponHeader.bounds.size.height/2 + 10 + 5);
    
    // Update the main bottom contentSize
    //
    _mainBottomView.contentSize = CGSizeMake(self.mainBottomView.contentSize.width,
                                             self.locationSectionView.origin.y + self.locationSectionView.height + 10);
    
}

- (void)removeCoupons {
    
    _locationSectionView.center = CGPointMake(self.locationSectionView.centerX,
                                              self.locationSectionView.centerY - self.smartOffset.y + self.couponHeader.centerY);
    
    // Configure smartOffset for the coupon dynamic offset
    //
    _smartOffset = CGPointMake(self.couponHeader.centerX,
                               self.couponHeader.bounds.size.height/2 + self.couponHeader.centerY);
    
    
    // Use the array to prevent dulplicate coupon views
    //
    [self.couponViews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [self.couponViews removeAllObjects];
}

- (void)configureCouponCell:(CouponObject *)couponObject withIndex:(NSInteger)index{
    
    if ([couponObject.couponType isEqualToString:@"gift"]) {
        
        if (!couponObject.backgroundPictureURL||[@"" isEqualToString:couponObject.backgroundPictureURL]) {
            HFCouponDisctountView *discountView = [[NSBundle mainBundle] loadNibNamed:@"HFCouponDisctountView" owner:self options:nil].lastObject;
            discountView.discountImg.image = [UIImage imageNamed:@"gift"];
            discountView.delegate = self;
            discountView.tag = index;
            
            discountView.briefDescriptionCN.text = couponObject.briefDescriptionCN;
            discountView.descCN.text = couponObject.descriptionCN;
            discountView.descCN.textColor = [UIColor lightGrayColor];
            discountView.descCN.textAlignment = NSTextAlignmentCenter;
            discountView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                              self.smartOffset.y + discountView.bounds.size.height/2);
            
            [self.mainBottomView addSubview:discountView];
            [self.couponViews addObject:discountView];
            
            // Update smart offset
            //
            _smartOffset = CGPointMake(self.smartOffset.x,
                                       self.smartOffset.y + discountView.bounds.size.height + 1);
            
        }else{
            
            HFCouponGiftView *giftView = [[NSBundle mainBundle] loadNibNamed:@"HFCouponGiftView" owner:self options:nil].lastObject;
            
            giftView.delegate = self;
            giftView.tag = index;
            
            NSURLRequest *storePicRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:couponObject.backgroundPictureURL]];
            [self fetchImageWithRequest:storePicRequest
                           finished:^(id responseObject) {
                               giftView.backgroundImageView.image = [[UIImage alloc]initWithData:responseObject];
             }];
            
            giftView.briefDescriptionCN.text = couponObject.briefDescriptionCN;
            giftView.descCN.text = couponObject.descriptionCN;
            giftView.descCN.textColor = [UIColor lightGrayColor];
            giftView.descCN.textAlignment = NSTextAlignmentCenter;
            giftView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                          self.smartOffset.y + giftView.bounds.size.height/2);
            
            [self.mainBottomView addSubview:giftView];
            [self.couponViews addObject:giftView];
            
            // Update smart offset
            //
            _smartOffset = CGPointMake(self.smartOffset.x,
                                       self.smartOffset.y + giftView.bounds.size.height);
        }
        
        
    }
    else {
        HFCouponDisctountView *discountView = [[NSBundle mainBundle] loadNibNamed:@"HFCouponDisctountView" owner:self options:nil].lastObject;
        
        discountView.delegate = self;
        discountView.tag = index;
        
        discountView.briefDescriptionCN.text = couponObject.briefDescriptionCN;
        discountView.descCN.text = couponObject.descriptionCN;
        discountView.descCN.textColor = [UIColor lightGrayColor];
        discountView.descCN.textAlignment = NSTextAlignmentCenter;
        discountView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                      self.smartOffset.y + discountView.bounds.size.height/2);
        
        [self.mainBottomView addSubview:discountView];
        [self.couponViews addObject:discountView];
        
        // Update smart offset
        //
        _smartOffset = CGPointMake(self.smartOffset.x,
                                   self.smartOffset.y + discountView.bounds.size.height + 1);
    }
    
}

#pragma mark - Configure Other Section View

- (void)configureStoreIntroduceSection {
    // Fetch cover image
    //
    NSURLRequest *logoRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.cellInfo.merchant.logoPictureURL]];
    [self fetchImageWithRequest:logoRequest finished:^(id responseObject) {
        self.storeLogoImage.image = [[UIImage alloc]initWithData:responseObject];
    }];
    
    _storeIntroduceLabel.text = self.cellInfo.storeIntroduction;
    
    [self configureReadMore];
}

- (void)configureStoreLocationInfoSection {
    
    NSString *addr = [NSString stringWithFormat:@"%@, %@", self.cellInfo.address, self.cellInfo.state];
    NSString *addrCN = [NSString stringWithFormat:@"%@, %@", self.cellInfo.addressCN, self.cellInfo.stateCN];
    
    _storeAddress.text = [NSString stringWithFormat:@"%@\n%@",addr,addrCN];
//    _storeAddressCN.text =
    
}

-(void)configureDistanceAndDuration
{
    BOOL timeShouldHide;
    if (self.cellInfo.distance) {
        if ([self.cellInfo.distance intValue] <= 2) {//2
            timeShouldHide = NO;
        } else{
            timeShouldHide = YES;
        }
    }else {
        timeShouldHide = YES;
    }
    NSString *text =
    [NSString stringWithFormat:@"%i公里%@",
     [self.cellInfo.distance intValue],
     [NSString stringWithFormat:@"%@",
      timeShouldHide? @"" :
      [NSString stringWithFormat:@",步行%d分钟",[self getWalkingDuration]]
      ]
     ];
    _storeDistanceAndTime.text = text;
    _distanceDurationLabel.text = text;
}

- (NSInteger )getWalkingDuration
{
    return round([self.cellInfo.distance floatValue] / 0.080467);
}

- (void)configureStoreOpeningSection {
    
    _mondayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.mondayOpenHour
                                 toCloseTime:self.cellInfo.storeHour.mondayCloseHour];
    _tuesdayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.tuesdayOpenHour
                                  toCloseTime:self.cellInfo.storeHour.tuesdayCloseHour];
    _wednesdayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.wednesdayOpenHour
                                    toCloseTime:self.cellInfo.storeHour.wednesdayCloseHour];
    _thursdayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.thrusdayOpenHour
                                   toCloseTime:self.cellInfo.storeHour.thrusdayCloseHour];
    _fridayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.fridayOpenHour
                                 toCloseTime:self.cellInfo.storeHour.fridayCloseHour];
    _saturdayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.saturdayOpenHour
                                   toCloseTime:self.cellInfo.storeHour.saturdayCloseHour];
    _sundayTime.text = [self openingTimeFrom:self.cellInfo.storeHour.sundayOpenHour
                                 toCloseTime:self.cellInfo.storeHour.sundayCloseHour];
    
}

- (NSString *)openingTimeFrom:(NSString *)openTime toCloseTime:(NSString *)closeTime {
    
    if ([openTime isEqual:[NSNull null]]) {
        return @"不营业";
    }
    else {
        return [NSString stringWithFormat:@"早%@到晚%@",
             [self convertOpenTime:openTime],
             [self convertOpenTime:closeTime]];
    }
}

- (NSString *)convertOpenTime:(NSString *)originString {
    
    NSInteger stringValue = originString.integerValue/100;
    
    if (stringValue%12 == 0) {
        return @"12";
    }
    
    return [NSString stringWithFormat:@"%i", stringValue%12];
    
}

- (void)configureServerSection {
    
    if (! self.cellInfo.hasTea && ! self.cellInfo.hasWifi && ! self.cellInfo.hasChineseSales) {
        
        _storeServiceViewSection.hidden = YES;
        
        CGFloat storeServiceViewSectionHeight = self.storeServiceViewSection.height;
        
        _smartOffset = CGPointMake(self.smartOffset.x, self.smartOffset.y - storeServiceViewSectionHeight);
        
        _storeIntroduceViewSection.center = CGPointMake(self.storeIntroduceViewSection.center.x, self.storeIntroduceViewSection.center.y - storeServiceViewSectionHeight);
        _couponHeader.center = CGPointMake(self.couponHeader.center.x, self.couponHeader.center.y - storeServiceViewSectionHeight);
        _locationSectionView.center = CGPointMake(self.locationSectionView.center.x, self.locationSectionView.center.y - storeServiceViewSectionHeight);
        
        // Store Basic View
        //
        _storeBasicInfoViewSection.layer.shadowOffset = CGSizeMake(0, 1);
        _storeBasicInfoViewSection.layer.shadowOpacity = 0.6f;
        _storeBasicInfoViewSection.layer.shadowRadius = 1;
        _storeBasicInfoViewSection.layer.shadowColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255 alpha:1.0].CGColor;
        
        NSLog(@"Layer Info : %@", self.storeBasicInfoViewSection);
        
    }
    
    if (! self.cellInfo.hasTea) {
        
        _hotTeaButton.hidden = YES;
    }
    
    if (! self.cellInfo.hasWifi) {
        
        _wifiButton.hidden = YES;
        
    }
    
    if (! self.cellInfo.hasChineseSales) {
        
        _chineseButton.hidden = YES;
        
    }
    
}

#pragma mark - Navigation Items

- (void)leftBarButtonItemTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightBarButtonItemTapped {
    if(![UserServerApi sharedInstance].currentUserId){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:@"请登录您的个人账户" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!self.isliked) {
        [Appsee addEvent:@"StoreDetailLike" withProperties:@{@"couponId":self.cellInfo.storeId}];
        [self favoriteStoreId:self.cellInfo];
        [self favouriteAnimationWithButton];
        UIButton *button = (UIButton *)self.rightItem.customView;
        [button setImage:[UIImage imageNamed:@"detail_like"] forState:UIControlStateNormal];
        _isliked = YES;
        return ;
    }
    [Appsee addEvent:@"StoreDetailUnlike" withProperties:@{@"couponId":self.cellInfo.storeId}];
    [self unfavoriteStoreId:self.cellInfo];
    UIButton *button = (UIButton *)self.rightItem.customView;
    [button setImage:[UIImage imageNamed:@"detail_unlike"] forState:UIControlStateNormal];
    _isliked = NO;

    
}

#pragma mark - Like Button Animations

- (void)favouriteAnimationWithButton {
    
    self.fakeLikeButton.hidden = NO;
    
    CGPoint likeButtonCenter = self.fakeLikeButton.center;
    
    // Fetch the tab Bar Item
    //
    CGPoint finalPoint = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, [UIScreen mainScreen].bounds.size.height - 25);
    
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
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [self.fakeLikeButton.layer addAnimation:animationGroup forKey:@""];
    
    // Remove the fake like button once the animation stop
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.69f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fakeLikeButton.hidden = YES;

    });
    
}

- (CGPoint)makeTopPoint:(CGPoint)startPoint {
    
    return CGPointMake(startPoint.x - 30, startPoint.y - 30);
    
}

#pragma mark - UIScroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y <= 0) {
        CGFloat scale = ((scrollView.contentOffset.y /340)*2) - 1;
        
        _goodsBottomView.transform = CGAffineTransformMakeScale(-scale, -scale);
        _goodsBottomView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.goodsBottomView.bounds.size.height/2 + 40 * (scale + 1));
        
    }

    // When offset larger than 40, stopping scroll
    //
    if (scrollView.contentOffset.y < -40) {
        [scrollView setContentOffset:CGPointMake(0, -40)];
    }

}

#pragma mark - MKAnnotation Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"PinAnnotation"];
    annotationView.image = [UIImage imageNamed:@"pin_blue"];
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [Appsee addEvent:@"StoreDetailMapChanged"];
}

#pragma mark - Goods View Animations

- (void)goodsForwardScrollTo:(NSInteger)page {

    // Use this property to avoid the memory increasing problems
    //
    if (self.animationStop || self.cellInfo.storePictureURLs.count == 1) {
        
        return ;
    }
    
    if (page > self.cellInfo.storePictureURLs.count) {
        
        [self goodsBackwardScrollTo:page - 1];
        return ;
    }
    
    [UIView animateWithDuration:0.3
                          delay:2.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                     
                         [self.goodsScrollView setContentOffset:CGPointMake(320 * (page - 1), 0)];
                         _goodsPageControl.currentPage = page - 1;
                     
                     }
                     completion:^(BOOL finished) {
                     
                         [self goodsForwardScrollTo:page + 1];
                     
                     }];
    
}

- (void)goodsBackwardScrollTo:(NSInteger)page {
    
    if (page == 0) {
        
        NSLog(@"Start : %i", page);
        
        [self goodsForwardScrollTo:1];
        return ;
    }
    
    [UIView animateWithDuration:0.3
                          delay:2.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [self.goodsScrollView setContentOffset:CGPointMake(320 * (page - 1), 0)];
                         _goodsPageControl.currentPage = page - 1;                         
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self goodsBackwardScrollTo:page - 1];
                         
                     }];
    
}

#pragma mark - Discount Button Tapped

- (IBAction)useDiscount:(id)sender {

    HFDiscountViewController *discountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"discountView"];
    //[self presentViewController:discountViewController animated:YES completion:nil];
    discountViewController.coupon = self.cellInfo.coupons[0];
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:discountViewController animated:YES];
}

- (IBAction)useSecondDiscount:(id)sender {
    HFDiscountViewController *discountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"discountView"];
    //[self presentViewController:discountViewController animated:YES completion:nil];
    discountViewController.coupon = self.cellInfo.coupons[1];
    discountViewController.salesName = self.cellInfo.salesName;
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:discountViewController animated:YES];
    
}

#pragma mark - Start Location Action

- (IBAction)startLocationTapped:(id)sender {
      
    NSString *mapURLString = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@,%@&saddr=%1.6f,%1.6f",self.cellInfo.latitude, self.cellInfo.longitude,[HFLocationManager sharedInstance].currentLocation.coordinate.latitude,[HFLocationManager sharedInstance].currentLocation.coordinate.longitude];
    
    NSURL *mapURL = [NSURL URLWithString:mapURLString];
    [[UIApplication sharedApplication]openURL:mapURL];
}

#pragma mark - Storyboard Stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    HFStoreIntroductionViewController *storeIntroductionViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"pushDetail"]) {
        storeIntroductionViewController.detailText = self.cellInfo.storeIntroduction;
        storeIntroductionViewController.storeLogoURL = self.cellInfo.merchant.logoPictureURL;
    }
    
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

- (void)favoriteStoreId:(StoreObject *)store
{
    //call api
    [HFUserApi favoriteStoreId:store.storeId
                    withUserId:[UserServerApi sharedInstance].currentUserId
                       success:^{
                           NSLog(@"Favorite Store Success");
                           //save to local
                           NSMutableArray* storeArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                           if (!storeArray) {
                               storeArray = [NSMutableArray new];
                           }
                           [storeArray addObject:store];
                           [HFGeneralHelpers saveData:storeArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                           [[NSNotificationCenter defaultCenter] postNotificationName:HFAddStoreToFavorite object:store userInfo:nil];
                           NSLog(@"Store Saved To Local");
                       } failure:^(NSError *error) {
                           NSLog(@"%@", error);
                       }];
}

- (void)unfavoriteStoreId:(StoreObject *)store
{
    //call api
    [HFUserApi unfavoriteStoreId:store.storeId
                      withUserId:[UserServerApi sharedInstance].currentUserId
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
                             [[NSNotificationCenter defaultCenter] postNotificationName:HFRemoveStoreToFavorite object:store userInfo:nil];
                             NSLog(@"Store Removed From Local");
                         } failure:^(NSError *error) {
                             NSLog(@"%@", error);
                         }];
    
    
}

#pragma mark - Discount Cell Delegate

- (void)discountCell:(UIButton *)button {
    
    NSLog(@"Super view tag : %i", button.superview.tag);
    
    HFDiscountViewController *discountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"discountView"];
    CouponObject *coupon = self.cellInfo.coupons[button.superview.tag];
    [Appsee addEvent:@"UseCoupon" withProperties:@{@"couponId":coupon.couponId}];
    discountViewController.coupon = coupon;
    discountViewController.salesName = self.cellInfo.merchant.merchantName;
    
    NSLog(@"Sale name : %@", self.cellInfo.salesName);
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:discountViewController animated:YES];
    
}

#pragma mark - Gift Cell Delegate

- (void)giftCell:(UIButton *)button {
    
    NSLog(@"Super view tag : %i", button.superview.tag);
    
    HFDiscountViewController *discountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"discountView"];
    CouponObject *coupon = self.cellInfo.coupons[button.superview.tag];
    [Appsee addEvent:@"UseCoupon" withProperties:@{@"couponId":coupon.couponId}];
    discountViewController.coupon = coupon;
    discountViewController.salesName = self.cellInfo.merchant.merchantName;

    NSLog(@"Sale name : %@", self.cellInfo);
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:discountViewController animated:YES];
    
}

#pragma mark - Serveice Action

- (IBAction)wifiButtonTapped:(id)sender {
    
    HFWifiViewController *wifiViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"wifi"];
    wifiViewController.blurBackgroundImage = [HFUIHelpers takeScreenShotForViewController:self andApplyBlurEffect:YES andBlurRadius:8];
    [self.navigationController pushViewController:wifiViewController animated:NO];
}

- (IBAction)chineseButtonTapped:(id)sender {
    
    HFChineseHelpViewController *chineseHelpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"chineseHelp"];
    chineseHelpViewController.blurBackgroundImage = [HFUIHelpers takeScreenShotForViewController:self andApplyBlurEffect:YES andBlurRadius:8];
    [self.navigationController pushViewController:chineseHelpViewController animated:NO];
}

- (IBAction)hotTeaButtonTapped:(id)sender {
    
    HFHotTeaViewController *hotTeaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotTea"];
    hotTeaViewController.blurBackgroundImage = [HFUIHelpers takeScreenShotForViewController:self andApplyBlurEffect:YES andBlurRadius:8];
    [self.navigationController pushViewController:hotTeaViewController animated:NO];
    
}

#pragma mark - Map Direction Stack

- (void)constructMapItems {
    
    // Fetch the destination map item via geocoder
    //
    CLGeocoder *destinationGeocoder = [[CLGeocoder alloc] init];
    CLLocation *destination = [[CLLocation alloc]initWithLatitude:self.cellInfo.latitude.floatValue longitude:self.cellInfo.longitude.floatValue];
    
    NSLog(@"");
    
    [destinationGeocoder reverseGeocodeLocation:destination completionHandler:
     ^(NSArray* placemarks, NSError* error){
         
         if ([placemarks count] > 0)
         {
             _destinationMapItem = [[MKMapItem alloc]initWithPlacemark:placemarks.lastObject];
         }
         
     }];
    
    // Fetch the current location map item via geocoder
    //
    CLGeocoder *currentLocationGeocoder = [[CLGeocoder alloc] init];
    CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:[HFLocationManager sharedInstance].currentLocation.coordinate.latitude longitude:[HFLocationManager sharedInstance].currentLocation.coordinate.longitude];
    
    [currentLocationGeocoder reverseGeocodeLocation:currentLocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         
         if ([placemarks count] > 0)
         {
             _currecntMapItem = [[MKMapItem alloc]initWithPlacemark:placemarks.lastObject];
         }
         
     }];
    
}

- (void)showDirectionFrom:(MKMapItem *)currentLocation toDestination:(MKMapItem *)destination {
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc]init];
    
    directionsRequest.source = currentLocation;
    directionsRequest.destination = destination;
//    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:directionsRequest];
    
    [SVProgressHUD show];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            
            NSLog(@"A error occur while requesting a map direction :%@", error.userInfo);
            
        }
        else {
            
            [self showRoute:response];
            
        }
        
    }];
    
}

- (void)showRoute:(MKDirectionsResponse *)directionResponse {
    
    for (MKRoute *route in directionResponse.routes) {
        
        [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
    }
    
    [SVProgressHUD dismiss];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    polylineRenderer.strokeColor = [UIColor blueColor];
    polylineRenderer.lineWidth = 3.0f;
    
    return polylineRenderer;
}

@end
