//
//  WeatherObject.h
//  HiFu
//
//  Created by Yin Xu on 6/29/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"

@interface WeatherObject : BaseObject

@property (nonatomic, strong) NSString *weatherType;
@property (nonatomic, strong) NSNumber *tempFahrenheit;
@property (nonatomic, strong) NSNumber *tempCelsius;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *relativeHumidity;
@property (nonatomic, strong) NSString *windDirection;

@end
