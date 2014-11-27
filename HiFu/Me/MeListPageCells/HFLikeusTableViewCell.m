//
//  HFLikeusTableViewCell.m
//  HiFu
//
//  Created by Peng Wan on 10/24/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFLikeusTableViewCell.h"


@implementation HFLikeusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 44;
}

+ (NSString *)reuseIdentifier
{
    return @"HFLikeusTableViewCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFLikeusTableViewCell" bundle:nil];
}
- (IBAction)likeUsButtonClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您认为'Hi米国'怎么样？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"还不错，鼓励一下",@"有意见，快速反馈", nil];
    [actionSheet showFromRect:self.likeUsButton.frame inView:self.container animated:YES];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%i",buttonIndex);
    switch (buttonIndex) {
        case 0:
            break;
        default:
            break;
    }
}

@end
