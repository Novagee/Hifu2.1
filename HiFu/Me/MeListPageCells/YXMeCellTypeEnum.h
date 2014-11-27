//
//  YXMeCellTypeEnum.h
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

typedef enum {
	MeInfoCell = 0,
    MeInfoTitleCell,
    MeNotificationCell,
    MeUsedCouponCell,
    MeFavoriteBrandsCell,
    MeRateUsCell,
    MeSpacingCell,
    
    MeBindingTitleCell,
    MeBindingWeiboCell,
    MeBindingQQCell,
    MeBindingWechatCell,
    MeBindingMobileCell,
    MeTermsCell,
    
    MeMoreTitleCell,
    MeMoreGenderCell,
    MeMoreAgeCell,
    
    MeLikeUsCell,
    
    MEUserLogin,
} YXMeCellType;


typedef enum {
	AvatarSettingCell = 0,
    NameSettingCell,
    PhoneNumberSettingCell,
    GenderSettingCell,
    CountrySettingCell
} YXMeInfoSettingCellType;