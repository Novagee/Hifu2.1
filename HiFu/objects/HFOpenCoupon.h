//
//  HFOpenCoupon.h
//  HiFu
//
//  Created by Peng Wan on 11/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "BaseObject.h"

@interface HFOpenCoupon : BaseObject

@property (nonatomic, strong) NSNumber  *couponId;
@property (nonatomic, strong) NSString  *type;
@property (nonatomic, strong) NSNumber  *status;
@property (nonatomic, strong) NSString  *brand;
@property (nonatomic, strong) NSString  *brandCN;
@property (nonatomic, strong) NSString  *effectDateDisplay;
@property (nonatomic, strong) NSString  *expireDateDisplay;
@property (nonatomic, assign) NSString  *title;
@property (nonatomic, assign) NSString  *titleCN;
@property (nonatomic, assign) NSString  *descriptionCN;
@property (nonatomic, assign) NSString  *brandPicUrl;
@property (nonatomic, assign) NSString  *couponPicUrl;
@property (nonatomic, assign) NSNumber  *browseNumber;
@property (nonatomic, strong) NSNumber  *timestamp;
@property (nonatomic, strong) UIImage *couponImage;

@end
