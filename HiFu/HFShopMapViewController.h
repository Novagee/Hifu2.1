//
//  HFMapViewController.h
//  HiFu
//
//  Created by Peng Wan on 10/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HFShopListViewController.h"

@interface HFShopMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIView *rangeViewSection;

@property (assign, nonatomic) kStoreCity currentStoreCity;

@end
