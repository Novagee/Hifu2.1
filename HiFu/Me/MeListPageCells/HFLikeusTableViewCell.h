//
//  HFLikeusTableViewCell.h
//  HiFu
//
//  Created by Peng Wan on 10/24/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HFGeneralCellProtocol.h"

@interface HFLikeusTableViewCell : UITableViewCell<HFGeneralCellProtocol,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *likeUsButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end
