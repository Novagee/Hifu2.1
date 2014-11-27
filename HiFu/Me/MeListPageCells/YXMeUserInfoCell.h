//
//  YXMeSettingCell.h
//  HiFu
//
//  Created by Yin Xu on 7/1/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface YXMeUserInfoCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *userAvatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userPhoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *hintLabel;
@property (nonatomic, weak) IBOutlet UIImageView *topSeparatorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomSeparatorImageView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end
