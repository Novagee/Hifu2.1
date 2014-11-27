//
//  HFBasicMapAnnotation.h
//  HiFu
//
//  Created by Yin Xu on 8/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class StoreObject;
@interface HFBasicMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) StoreObject *store;

@property (nonatomic, assign) int tag;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
              andStore:(StoreObject *)storeObject;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end