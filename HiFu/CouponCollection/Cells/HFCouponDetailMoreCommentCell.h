//
//  HFCouponDetailMoreCommentCell.h
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@interface HFCouponDetailMoreCommentCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIButton *moreCommentsButton;

- (IBAction)moreCommentsButtonTapped:(id)sender;

@end
