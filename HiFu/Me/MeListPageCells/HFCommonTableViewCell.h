//
//  HFCommonTableViewCell.h
//  HiFu
//
//  Created by Peng Wan on 12/4/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface HFCommonTableViewCell : UITableViewCell <HFGeneralCellProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
