//
//  HFGenderTableViewCell.h
//  HiFu
//
//  Created by Peng Wan on 10/24/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface HFGenderTableViewCell : UITableViewCell<HFGeneralCellProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (nonatomic, weak) IBOutlet UIImageView *topSeparatorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomSeparatorImageView;

@end
