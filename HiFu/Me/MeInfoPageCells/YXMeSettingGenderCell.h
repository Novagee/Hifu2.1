//
//  YXMeSettingGenderCell.h
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface YXMeSettingGenderCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UISegmentedControl *genderSegmentedControl;

- (IBAction)genderSgmentedControlValueChanged:(id)sender;

@end
