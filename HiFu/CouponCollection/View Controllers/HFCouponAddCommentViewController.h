//
//  HFCouponAddCommentViewController.h
//  HiFu
//
//  Created by Yin Xu on 8/4/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentObject, CouponObject;
@interface HFCouponAddCommentViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *textCountLabel;

@property (nonatomic, strong) CommentObject *currentUserComment;
@property (nonatomic, strong) CouponObject *coupon;

- (IBAction)doneButtonTapped:(id)sender;

@end
