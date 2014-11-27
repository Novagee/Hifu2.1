//
//  HFBasicMapAnnotation.m
//  HiFu
//
//  Created by Yin Xu on 8/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFBasicMapAnnotation.h"

@implementation HFBasicMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
{
    return [self initWithLatitude:latitude andLongitude:longitude andStore:nil];
}


- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
              andStore:(StoreObject *)storeObject
{
    if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.store = storeObject;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}


@end
