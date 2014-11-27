//
//  YXMeSettingPhoneCell.h
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface YXMeSettingPhoneCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *userPhoneNumberLabel;

@end
