//
//  YXMeSettingNameCell.h
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface YXMeSettingNameCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UITextField *userNameTextField;

@end
