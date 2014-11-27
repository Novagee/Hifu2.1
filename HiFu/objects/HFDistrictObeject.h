//
//  DistrictObeject.h
//  HiFu
//
//  Created by Peng Wan on 11/2/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "BaseObject.h"
#import "CityObject.h"

@interface HFDistrictObeject : BaseObject

@property (nonatomic, strong) NSString *districtName;
@property (nonatomic, strong) NSString *districtNameCN;
@property (nonatomic, strong) NSNumber *centerLatitude;
@property (nonatomic, strong) NSNumber *centerLongitude;
@property (nonatomic, strong) CityObject *city;

@end
