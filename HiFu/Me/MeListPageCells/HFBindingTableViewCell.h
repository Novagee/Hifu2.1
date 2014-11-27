//
//  HFBindingTableViewCell.h
//  HiFu
//
//  Created by Peng Wan on 10/24/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface HFBindingTableViewCell : UITableViewCell<HFGeneralCellProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *bindingImage;
@property (weak, nonatomic) IBOutlet UILabel *bindingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *bindingSwitch;
@property (nonatomic, weak) IBOutlet UIImageView *topSeparatorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomSeparatorImageView;
@end
