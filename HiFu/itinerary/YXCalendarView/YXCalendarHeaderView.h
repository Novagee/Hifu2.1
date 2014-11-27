//
//  YXCalendarHeaderView.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXCalendarHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIButton *lastMonthButton;
@property (nonatomic, weak) IBOutlet UIButton *nextMonthButton;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *dayLabels;

+(id)sharedInstance;

@end
