//
//  HFBrandListTableViewCell.m
//  HiFu
//
//  Created by Peng Wan on 10/7/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFShopListTableViewCell.h"
#import "CALayer+CGCategories.h"
#import "UIImageView+WebCache.h"

#import "StoreObject.h"
#import "HFCategory.h"
#import "HFLocationManager.h"
#import "HFGeneralHelpers.h"
#import "UIView+EasyFrames.h"

#define kServerLabelCenterY 27
#define kServerDotCenterY 27

#define kGoodTypeLabelCenterY 108
#define kGoodTypeDotCenterY 108

@interface HFShopListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *goodsTypeBottom;

@property (strong, nonatomic) NSMutableArray *storeServerType;
@property (strong, nonatomic) NSMutableDictionary *openingTimes;
@property (weak, nonatomic) IBOutlet UIView *gradientView;

@property (weak, nonatomic) IBOutlet UIView *infoViewBottom;
@property (assign, nonatomic) CGFloat currentServiceOffset;
@property (assign, nonatomic) CGFloat currentGoodsTypeOffset;

@end

@implementation HFShopListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Sub Button's Action

- (IBAction)likeButtonTapped:(UIButton *)button {
    
    NSLog(@"Cell like button tapped, using delegate : %@", self.delegate);
    
    if ([self.delegate respondsToSelector:@selector(handleShopListLikeButton:)]) {
        [self.delegate handleShopListLikeButton:button];
        
        NSLog(@"Response to selector");
    }
    
}

#pragma mark - Configure Cell

- (void)constructCellBasedOnCoupon:(StoreObject *)store {
    // Restore the cell to a default status
    //
    [self restoreUIControlsDefaultSetting];
    
    // Configure cell by "store"
    //
    [self.storeLogo setImageWithURL:[NSURL URLWithString:store.coverPictureURL]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (image && !error) {
                                      store.coverImage = image;
                                      self.storeLogo.image = image;
                                  }
                              }];
    
    self.storeNameCN.text = store.merchant.merchantNameCN;
    self.storeNameEN.text = store.merchant.merchantName;
    [self configureGoodsType:store.categories];
    
    // Configure Gradient Color
    //
    [self configureGradientView];
    
    // Configure Store location
    //
    self.storeLocationName.text = store.storeName;
    [self configureStoreLocationName];
    
    // Configure gift and discount
    //
    if (store.hasGift) {
        
        self.giftImageView.hidden = NO;
        self.giftLabel.hidden =NO;
        
    }
    if (store.hasDiscount) {
        
        self.discountImageView.hidden = NO;
        self.discountLabel.hidden =NO;
        
    }
    
    _storeServerType = [[NSMutableArray alloc]init];
    
    // Configure Store Service
    //
    if (store.hasTea) {
        [self.storeServerType addObject:@"热茶"];
    }
    if (store.hasWifi) {
        [self.storeServerType addObject:@"免费上网"];
    }
    if (store.hasChineseSales) {
        [self.storeServerType addObject:@"中文服务"];
    }
    [self configureStoreServerType:self.storeServerType];
    
    // Configure Store opening stuff
    //
    [self configureDateStuff];
    [self configureOpeningTime];
    
    //Configure like
    NSMutableArray* storeArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
    NSLog(@"LikedStoreCount:%i",storeArray.count);
    BOOL flag = NO;
    for (StoreObject *storeObj in storeArray) {
        NSLog(@"store.storeId:%@",store.storeId);
        NSLog(@"storeObj.storeId:%@",storeObj.storeId);
        if (storeObj&&storeObj.storeId&&storeObj.storeId.intValue == store.storeId.intValue) {
            flag = YES;
        }
    }
    if (flag) {
        [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    }
    
    self.liked = flag;
    NSLog(@"Distance : %@", store.distance);
    
    if (store.distance) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%d 公里", [store.distance intValue]];
        self.distanceLabel.hidden = NO;
        if ([store.distance intValue] <= 2) {//2
            self.timeLable.text = [NSString stringWithFormat:@"步行%d分钟",[self getWalkingDuration]];
            self.timeLable.hidden = NO;
        } else{
            self.timeLable.hidden = YES;
        }
    }else {
        self.distanceLabel.hidden = YES;
        self.timeLable.hidden = YES;
    }
    
    self.distanceLabel.textColor = [UIColor colorWithPatternImage:[self gradientImage:self.distanceLabel.text withSize:16]];
    self.timeLable.textColor = [UIColor colorWithPatternImage:[self gradientImage:self.timeLable.text withSize:16]];
    self.storeNameCN.textColor = [UIColor colorWithPatternImage:[self gradientImage:self.storeNameCN.text withSize:20]];
    self.storeNameEN.textColor = [UIColor colorWithPatternImage:[self gradientImage:self.storeNameEN.text withSize:20]];
}

- (void)configureGradientView {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.gradientView.bounds;
    
    UIColor *startColor = [UIColor colorWithRed:53/255.0f green:53/255.0f blue:53/255.0f alpha:0.8];
    UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    
    [self.gradientView.layer addSublayer:gradientLayer];
}

- (void)configureGoodsType:(NSMutableArray *)goodsTypeInfo {
    
    switch (goodsTypeInfo.count) {
            
        case 0:
            return ;
            break;
        case 1:

            [self addGoodsTypeLabel:goodsTypeInfo[0]];
            
            break;
        case 2:
            
            [self addGoodsTypeLabel:goodsTypeInfo[0]];
            
            [self addGoodTypeDotByOffset:self.currentGoodsTypeOffset];
            
            [self addGoodsTypeLabel:goodsTypeInfo[1]];
            
            break;
        case 3:
            
            [self addGoodsTypeLabel:goodsTypeInfo[0]];
            
            [self addGoodTypeDotByOffset:self.currentGoodsTypeOffset];
            
            [self addGoodsTypeLabel:goodsTypeInfo[1]];
            
            [self addGoodTypeDotByOffset:self.currentGoodsTypeOffset];
            
            [self addGoodsTypeLabel:goodsTypeInfo[2]];
            
            break;
            
        default:
            break;
    }
    
}

- (void)configureStoreServerType:(NSMutableArray *)storeServerType {
    
    switch (storeServerType.count) {
            
        case 0:
            return ;
            break;
        case 1:
            
            [self addServerLabel:storeServerType[0]];
            
            break;
        case 2:
            
            [self addServerLabel:storeServerType[0]];
            [self addServerDotByOffset:self.currentServiceOffset];
            
            [self addServerLabel:storeServerType[1]];
            
            break;
        case 3:
            
            [self addServerLabel:storeServerType[0]];
            [self addServerDotByOffset:self.currentServiceOffset];
            
            [self addServerLabel:storeServerType[1]];
            [self addServerDotByOffset:self.currentServiceOffset];
            
            [self addServerLabel:storeServerType[2]];
            break;
            
        default:
            break;
    }
    
}

- (void)restoreUIControlsDefaultSetting {
    
    _currentServiceOffset = self.infoViewBottom.width - 20;
    _currentGoodsTypeOffset = 20;
    
    [_gradientView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_goodsTypeBottom.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    [_infoViewBottom.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    // Invoke the method for solve the cell reused machanism confilct
    //
    self.giftLabel.hidden = YES;
    self.giftImageView.hidden = YES;
    self.discountLabel.hidden = YES;
    self.discountImageView.hidden = YES;
    self.isOpeningLabel.text = @"已休息";
    
}

- (void)configureStoreLocationName {
    
    // Dynamic
    
//    self.storeNameImage.frame = CGRectMake(self.storeNameImage.origin.x, self.storeNameImage.origin.x, self.storeNameImage.bounds.size.width * self.store.storeName.length/13, self.storeNameImage.frame.size.height);
    
}

#pragma mark - Store Date Stuff

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
            self.isOpeningLabel.text = @"营业中";        
    }
    
    
    // Configure Opeing time
    //
    self.openingTime.text = [NSString stringWithFormat:@"早%@%@到晚%@%@营业",
                             [self convertOpenTime:openHour],
                             openMinute == 0? @"":[NSString stringWithFormat:@":%i", openMinute],
                             [self convertOpenTime:closeHour],
                             closeMinute == 0? @"": [NSString stringWithFormat:@":%i", closeMinute]
                             ];
    
}

- (void)configureDateStuff {
    
    // Store the date into the dictionary
    //
    if (! _openingTimes) {
        _openingTimes = [[NSMutableDictionary alloc]init];
    }
    
    [_openingTimes setValue:@[self.store.storeHour.mondayOpenHour ? : @"",
                              self.store.storeHour.mondayCloseHour ? : @""]
                     forKey:@"Mon"];
    [_openingTimes setValue:@[self.store.storeHour.tuesdayOpenHour ? : @"",
                              self.store.storeHour.tuesdayCloseHour ? : @""]
                     forKey:@"Tue"];
    [_openingTimes setValue:@[self.store.storeHour.wednesdayOpenHour ? : @"",
                              self.store.storeHour.wednesdayCloseHour ? : @""]
                     forKey:@"Wed"];
    [_openingTimes setValue:@[self.store.storeHour.thrusdayOpenHour ? : @"",
                              self.store.storeHour.thrusdayCloseHour ? : @""]
                     forKey:@"Thu"];
    [_openingTimes setValue:@[self.store.storeHour.fridayOpenHour ? : @"",
                              self.store.storeHour.fridayCloseHour ? : @""]
                     forKey:@"Fri"];
    [_openingTimes setValue:@[self.store.storeHour.saturdayOpenHour ? : @"",
                              self.store.storeHour.saturdayCloseHour ? : @""]
                     forKey:@"Sat"];
    [_openingTimes setValue:@[self.store.storeHour.sundayOpenHour ? : @"",
                              self.store.storeHour.sundayCloseHour ? : @""]
                     forKey:@"Sun"];
}

- (NSString *)convertOpenTime:(NSInteger )originString {
    
    if (originString == 12) {
        return [NSString stringWithFormat:@"%i", originString];
    }
    
    return [NSString stringWithFormat:@"%i", originString%12];
}

- (NSInteger )getWalkingDuration
{
    return round([self.store.distance floatValue] / 0.080467);
}

- (UIImage *)gradientImage:(NSString *)text withSize:(int) fontSize
{
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:HelveticaNeue_Regular(fontSize)}];
    CGFloat width = textSize.width;         // max 1024 due to Core Graphics limitations
    CGFloat height = textSize.height;       // max 1024 due to Core Graphics limitations
    
    // create a new bitmap image context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);
    
    //draw gradient
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 1.0,  // Start color
        1.0, 1.0, 1.0, 0.9 }; // End color
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, textSize.height);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // pop context
    UIGraphicsPopContext();
    
    // get a UIImage from the image context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return  gradientImage;
}

- (void)addServerLabel:(NSString *)title{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, title.length * 14, 14)];
    label.font = [UIFont fontWithName:@"SimHei" size:14];
    label.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.center = CGPointMake(self.currentServiceOffset - label.width/2, kServerLabelCenterY);

    [self.infoViewBottom addSubview:label];
    
    NSLog(@"Label : %@", label);
    
    _currentServiceOffset = _currentServiceOffset - label.width;
}

- (void)addServerDotByOffset:(CGFloat)offset {
    
    UIImageView *dotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 4)];
    dotImageView.image = [UIImage imageNamed:@"dot"];
    dotImageView.center = CGPointMake(self.currentServiceOffset - 6 - dotImageView.width/2, kServerDotCenterY);
    
    [self.infoViewBottom addSubview:dotImageView];
    
    _currentServiceOffset = _currentServiceOffset - dotImageView.width - 6 * 2;
}

- (void)addGoodsTypeLabel:(NSString *)title{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, title.length * 14, 14)];
    label.font = [UIFont fontWithName:@"SimHei" size:14];
    label.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.center = CGPointMake(self.currentGoodsTypeOffset + label.width/2, kGoodTypeLabelCenterY);
    
    [self.goodsTypeBottom addSubview:label];
    
    NSLog(@"Goods Type Label : %@", label);
    
    _currentGoodsTypeOffset = _currentGoodsTypeOffset + label.width;
}

- (void)addGoodTypeDotByOffset:(CGFloat)offset {
    
    UIImageView *dotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 4)];
    dotImageView.image = [UIImage imageNamed:@"dot"];
    dotImageView.center = CGPointMake(self.currentGoodsTypeOffset + 6 + dotImageView.width/2, kGoodTypeDotCenterY);
    
    [self.goodsTypeBottom addSubview:dotImageView];
    
    _currentGoodsTypeOffset = _currentGoodsTypeOffset + dotImageView.width + 6 * 2;
    
}

@end
