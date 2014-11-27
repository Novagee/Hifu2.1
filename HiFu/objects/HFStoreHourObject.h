//
//  HFStoreHourObject.h
//  HiFu
//
//  Created by Peng Wan on 11/2/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "BaseObject.h"

@interface HFStoreHourObject : BaseObject
@property (nonatomic, strong) NSString *mondayOpenHour;
@property (nonatomic, strong) NSString *mondayCloseHour;
@property (nonatomic, strong) NSString *tuesdayOpenHour;
@property (nonatomic, strong) NSString *tuesdayCloseHour;
@property (nonatomic, strong) NSString *wednesdayOpenHour;
@property (nonatomic, strong) NSString *wednesdayCloseHour;
@property (nonatomic, strong) NSString *thrusdayOpenHour;
@property (nonatomic, strong) NSString *thrusdayCloseHour;
@property (nonatomic, strong) NSString *fridayOpenHour;
@property (nonatomic, strong) NSString *fridayCloseHour;
@property (nonatomic, strong) NSString *saturdayOpenHour;
@property (nonatomic, strong) NSString *saturdayCloseHour;
@property (nonatomic, strong) NSString *sundayOpenHour;
@property (nonatomic, strong) NSString *sundayCloseHour;
@end
