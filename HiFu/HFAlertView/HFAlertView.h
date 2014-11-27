//
//  HFAlertView.h
//  HiFu
//
//  Created by Yin Xu on 8/30/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFAlertView : UIView

@property (nonatomic, weak) IBOutlet UIButton *dismissButton;
@property (nonatomic, weak) IBOutlet UIView *mainView;

+ (HFAlertView *)sharedInstance;
+ (void)show;

- (IBAction)dismissButtonPressed:(id)sender;

@end
