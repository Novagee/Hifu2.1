//
//  HFCouponDetailMoreCommentCell.m
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponDetailMoreCommentCell.h"

@implementation HFCouponDetailMoreCommentCell

- (void)awakeFromNib
{
//    self.moreCommentsButton.layer.borderColor = [[UIColor colorWithWhite:0.824 alpha:1.000] CGColor];
//    self.moreCommentsButton.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 44;
}

+ (NSString *)reuseIdentifier
{
    return @"HFCouponDetailMoreCommentCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFCouponDetailMoreCommentCell" bundle:nil];
}

- (IBAction)moreCommentsButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HFCouponDetailMoreComment object:self.moreCommentsButton userInfo:nil];
}

@end
