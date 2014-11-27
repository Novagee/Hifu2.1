//
//  cityObject.h
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"

@interface CityObject : BaseObject

@property (nonatomic, strong) NSString *nameUS;
@property (nonatomic, strong) NSString *nameCN;
@property (nonatomic, strong) NSString *stateUS;
@property (nonatomic, strong) NSString *stateUSShort;
@property (nonatomic, strong) NSString *stateCN;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSNumber *tax;

@end
