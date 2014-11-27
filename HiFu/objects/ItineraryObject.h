//
//  itineraryObject.h
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"

@interface ItineraryObject : BaseObject

@property (nonatomic, strong) NSNumber *cityId;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;


@end
