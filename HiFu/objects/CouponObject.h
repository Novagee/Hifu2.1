//
//  CouponObject.h
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"
@class MerchantObject;
@interface CouponObject : BaseObject

@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleCN;
@property (nonatomic, strong) NSString *shortTitle;
@property (nonatomic, strong) NSString *shortTitleCN;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *descriptionEN;
@property (nonatomic, strong) NSString *descriptionCN;
@property (nonatomic, strong) NSNumber *originPrice;
@property (nonatomic, strong) NSNumber *realPrice;
@property (nonatomic, strong) NSNumber *discountPercentage;
@property (nonatomic, strong) NSNumber *discountMinAmount;
@property (nonatomic, assign) BOOL hasRedeemCode;
@property (nonatomic, strong) NSString *redeemCodeType;
@property (nonatomic, strong) NSString *redeemCode;
@property (nonatomic, strong) NSString *redeemCodePic;
@property (nonatomic, strong) NSString *coverPic;
@property (nonatomic, strong) NSString *promotionPic;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *categoryCN;
@property (nonatomic, strong) NSString *numberUsed;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSDate *expiredAt;
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, assign) BOOL isExclusiveCMB;
@property (nonatomic, assign) BOOL isCombinedUsed;
@property (nonatomic, assign) BOOL isAllStore;
@property (nonatomic, assign) BOOL isInstore;
@property (nonatomic, assign) BOOL isContractor;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) MerchantObject *merchant;
@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) UIImage *promotionImage;
@property (nonatomic, strong) UIImage *redeemImage;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, strong) NSString *sharePictureURL;
@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) NSString *backgroundPictureURL;
@property (nonatomic, strong) NSString *couponType;
@property (nonatomic, strong) NSNumber *couponId;
@property (nonatomic, strong) NSNumber *storeId;
@property (nonatomic, assign) BOOL hasCMBWatermark;
@property (nonatomic, strong) NSString *brandLogoPictureURL;
@property (nonatomic, strong) NSString *briefDescriptionCN;
@property (nonatomic, strong) NSString *code;

@end
