//
//  HFCouponCollectionTypeEnum.h
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

typedef enum {
    HFCouponCollectionNew = 0,
    HFCouponCollectionFavorite,
    HFCouponCollectionPopular
} HFCouponCollectionType;


typedef enum {
    HFCouponFailureUnknow = 0,
    HFCouponWrongCouponError,
    HFCouponMoneyError,
    HFCouponStoreError,
    HFCouponTimeError
} HFCouponRedeemFailureType;