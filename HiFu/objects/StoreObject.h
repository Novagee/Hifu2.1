//
//  StoreObject.h
//  HiFu
//
//  Created by Yin Xu on 8/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "BaseObject.h"
#import "MerchantObject.h"
#import "HFDistrictObeject.h"
#import "HFStoreHourObject.h"

@interface StoreObject : BaseObject

@property (nonatomic, strong) NSString  *merchantId;
@property (nonatomic, strong) NSNumber  *storeId;
@property (nonatomic, strong) NSString  *storeName;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *city;
@property (nonatomic, strong) NSString  *state;
@property (nonatomic, strong) NSString  *zipCode;
@property (nonatomic, strong) NSString  *shoppingCenterName;
@property (nonatomic, strong) NSString  *shoppingCenterZone;
@property (nonatomic, strong) NSString  *phoneNum;
@property (nonatomic, strong) NSNumber  *latitude;
@property (nonatomic, strong) NSNumber  *longitude;
@property (nonatomic, strong) NSArray   *dayWorkHours;

//New fields for v2
@property (nonatomic, strong) NSMutableArray    *coupons;//CouponObject
@property (nonatomic, strong) NSMutableArray    *categories;//HFCategoryObject
@property (nonatomic, strong) MerchantObject    *merchant;
@property (nonatomic, strong) HFDistrictObeject *district;
@property (nonatomic, strong) NSString          *addressCN;
@property (nonatomic, strong) NSString          *cityCN;
@property (nonatomic, strong) NSString          *stateCN;
@property (nonatomic, strong) NSString          *salesName;
@property (nonatomic, strong) NSString          *coverPictureURL;
@property (nonatomic, strong) NSMutableArray           *storePictureURLs;
@property (nonatomic, assign) BOOL              hasWifi;
@property (nonatomic, assign) BOOL              hasTea;
@property (nonatomic, assign) BOOL              hasChineseSales;
@property (nonatomic, assign) BOOL              hasDiscount;
@property (nonatomic, assign) BOOL              hasGift;
@property (nonatomic, assign) BOOL              acceptUnionPay;
@property (nonatomic, strong) HFStoreHourObject *storeHour;
@property (nonatomic, strong) NSString          *storeIntroduction;
@property (nonatomic, assign) BOOL              hasMultipleBrand;
@property (nonatomic, strong) NSMutableArray    *brands;//HFBrandObject
@property (nonatomic, strong) UIImage           *coverImage;

@property (strong, nonatomic) NSNumber *distance;

@property (nonatomic, strong) NSMutableArray *goodsInfo;
@property (nonatomic, strong) NSNumber *speed;

@end
