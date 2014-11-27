//
//  HFCouponDetailAddCommentCell.m
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponDetailAddCommentCell.h"

@implementation HFCouponDetailAddCommentCell

- (void)awakeFromNib
{
    self.addCommentButton.layer.borderColor = [[UIColor colorWithWhite:0.824 alpha:1.000] CGColor];
    self.addCommentButton.layer.borderWidth = 0.5;
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
    return @"HFCouponDetailAddCommentCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFCouponDetailAddCommentCell" bundle:nil];
}

- (IBAction)addCommentButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HFCouponDetailAddComment object:self userInfo:nil];
}

@end
