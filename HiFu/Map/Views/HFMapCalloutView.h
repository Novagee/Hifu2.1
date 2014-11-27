//
//  HFMapCalloutView.h
//  HiFu
//
//  Created by Yin Xu on 8/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFMapCalloutView : UIView

@property (nonatomic, weak) IBOutlet UIView *topWrapperView;
@property (nonatomic, weak) IBOutlet UILabel *storeAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIView *distanceWrapperView;
@property (nonatomic, weak) IBOutlet UILabel *storeOpeningTimeLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *storeAddressLabelHeightConstraint;

@end
