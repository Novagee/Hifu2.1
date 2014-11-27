//
//  HFCouponDetailAddCommentCell.h
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface HFCouponDetailAddCommentCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIButton *addCommentButton;

- (IBAction)addCommentButtonTapped:(id)sender;

@end
