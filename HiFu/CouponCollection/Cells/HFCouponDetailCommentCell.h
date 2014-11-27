//
//  HFCouponDetailCommentCell.h
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@class CommentObject;
@interface HFCouponDetailCommentCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *commentBubbleImageView;
@property (nonatomic, weak) IBOutlet UILabel *commentContentLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *commentBubbleBottomSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *commentContentBottomSpaceConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *userAvatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;

@property (nonatomic, strong) CommentObject *comment;

+ (float)cellHeightForComment:(CommentObject *)comment;

@end
