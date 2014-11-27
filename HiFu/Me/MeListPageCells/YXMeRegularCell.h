//
//  YXMeRegularCell.h
//  HiFu
//
//  Created by Yin Xu on 7/1/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface YXMeRegularCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *cellIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *topSeparatorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomSeparatorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, weak) IBOutlet UILabel *comingSoonLabel;
@property (nonatomic, weak) IBOutlet UISwitch *bindingSwitch;


@end
