//
//  WorkHourObject.h
//  HiFu
//
//  Created by Yin Xu on 8/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "BaseObject.h"

@interface WorkHourObject : BaseObject

@property (nonatomic, strong) NSNumber *weekDay;
@property (nonatomic, strong) NSString *openHour;
@property (nonatomic, strong) NSString *closeHour;

@end
