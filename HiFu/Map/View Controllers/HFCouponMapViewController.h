//
//  HFCouponMapViewController.h
//  HiFu
//
//  Created by Yin Xu on 8/7/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CouponObject;
@interface HFCouponMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *navbarTitleView;
@property (nonatomic, weak) IBOutlet UILabel *titleNameLabel;
@property (nonatomic, weak) IBOutlet UIView *bottomWrapperView;
@property (nonatomic, weak) IBOutlet UILabel *couponShortTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *couponExpireLabel;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;

@property (nonatomic, strong) CouponObject *coupon;
@property (nonatomic, strong) UIImage *logoImage;

@end
