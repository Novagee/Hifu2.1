//
//  HFCouponDetailCommentCell.m
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponDetailCommentCell.h"
#import "CommentObject.h"

@implementation HFCouponDetailCommentCell

- (void)awakeFromNib
{
    [HFUIHelpers roundCornerToHFDefaultRadius:self.commentBubbleImageView];
    self.commentBubbleImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)cellHeightForComment:(CommentObject *)comment
{
    int height = [HFGeneralHelpers getAttributedTextHeight:comment.content andFont:HeitiSC_Medium(13) andWidth:180 andLineSpace:3.0] + 10;
    
    return height <= 38 ? 78 : 40 + height;
}

+ (float)heightForCell
{
    return 78;
}

+ (NSString *)reuseIdentifier
{
    return @"HFCouponDetailCommentCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFCouponDetailCommentCell" bundle:nil];
}

@end
